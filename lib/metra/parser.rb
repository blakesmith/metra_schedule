# coding: utf-8

require 'nokogiri'
require 'open-uri'

module MetraSchedule
  class Parser
    attr_reader :html_doc, :tables, :trains
    attr_accessor :line

    def initialize(html_doc)
      @html_doc = html_doc
    end

    def scrape
      parse_nokogiri
      seperate_tables
      make_trains
    end

    def parse_nokogiri
      html_doc = open(@html_doc) if @html_doc.is_a?(String)
      html_doc = @html_doc if @html_doc.is_a?(File)
      @html_doc = Nokogiri::HTML(html_doc)
    end

    def seperate_tables
      tables = @html_doc.css('table.schedule')
      @tables = []
      @tables.push ({:schedule => :weekday, :direction => :inbound, :tables => [tables[0..1]].flatten})
      @tables.push ({:schedule => :saturday, :direction => :inbound, :tables => [tables[2]].flatten})
      @tables.push ({:schedule => :sunday, :direction => :inbound, :tables => [tables[3]].flatten})
      @tables.push ({:schedule => :weekday, :direction => :outbound, :tables => [tables[4..6]].flatten})
      @tables.push ({:schedule => :saturday, :direction => :outbound, :tables => [tables[7]].flatten})
      @tables.push ({:schedule => :sunday, :direction => :outbound, :tables => [tables[8]].flatten})
    end

    def make_trains
      @trains = []
      @tables.each do |t|
        t[:tables].each do |table|
          1.upto(train_count(table)).each do |count|
            new_train = MetraSchedule::Train.new :direction => t[:direction], \
              :schedule => t[:schedule], :stops => find_stops(table, count, t[:direction]), \
              :train_num => find_train_num(table, count)
            @trains.push(new_train)
          end
        end
      end
      @trains
    end

    def train_count(table)
      table.xpath('thead/tr[1]/th').count - 1
    end

    def stop_count(table)
      table.xpath('tbody').count
    end

    def make_stop(node, station_num, direction)
      node_text = node.text
      return nil if node_text == "– "
      time = Time.parse(node_text + am_or_pm(node))
      if direction == :inbound
        station = @line[:stations].reverse[station_num]
      else
        station = @line[:stations][station_num]
      end
      MetraSchedule::Stop.new :station => station, :time => time
    end

    def am_or_pm(node)
      klass = node.attributes["class"].value
      return 'AM' if klass == 'am'
      return 'PM' if klass == 'pm'
    end

    def find_train_num(table, count)
      text = table.xpath("thead/tr/th[#{count+1}]").text
      text.slice(0..-3).to_i #Chop off the AM/PM in the table
    end

    def find_stops(table, count, direction)
      stops = []
      1.upto(stop_count(table)).each do |stop_count|
        stop = make_stop(table.xpath("tbody[#{stop_count}]/tr/td[#{count}]")[0], stop_count - 1, direction)
        stops.push stop if stop
      end
      stops
    end

    def sanitize(input)
      input.delete_at(0) if input.is_a?(Array)
      input
    end

  end
end
