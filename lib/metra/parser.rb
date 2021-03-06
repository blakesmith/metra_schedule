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
      @tables << {:schedule => :weekday, :direction => :inbound, :tables => [tables[@line[:tables][:weekday_inbound]]].flatten} \
        if @line[:tables].has_key?(:weekday_inbound)
      @tables << {:schedule => :saturday, :direction => :inbound, :tables => [tables[@line[:tables][:saturday_inbound]]].flatten} \
        if @line[:tables].has_key?(:saturday_inbound)
      @tables << {:schedule => :sunday, :direction => :inbound, :tables => [tables[@line[:tables][:sunday_inbound]]].flatten} \
        if @line[:tables].has_key?(:sunday_inbound)
      @tables << {:schedule => :weekday, :direction => :outbound, :tables => [tables[@line[:tables][:weekday_outbound]]].flatten} \
        if @line[:tables].has_key?(:weekday_outbound)
      @tables << {:schedule => :saturday, :direction => :outbound, :tables => [tables[@line[:tables][:saturday_outbound]]].flatten} \
        if @line[:tables].has_key?(:saturday_outbound)
      @tables << {:schedule => :sunday, :direction => :outbound, :tables => [tables[@line[:tables][:sunday_outbound]]].flatten} \
        if @line[:tables].has_key?(:sunday_outbound)
    end

    def make_trains
      @trains = []
      @tables.each do |t|
        t[:tables].each do |table|
          1.upto(train_count(table)).each do |count|
            new_train = MetraSchedule::Train.new :direction => t[:direction], \
              :schedule => t[:schedule], :stops => find_stops(table, count, t[:direction]), \
              :train_num => find_train_num(table, count), :bike_limit => find_bike_count(table, count)
            @trains << new_train
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
      node_text = node_text[0..-2] if node_text.include?('x')
      return nil if node_text.strip == "–" || node_text.strip == "fd"
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

    def find_bike_count(table, count)
      num = table.xpath("thead/tr[3]/td[#{count}]").text.to_i
      if num == 0
        nil
      else
        num
      end
    end

    def find_stops(table, count, direction)
      stops = []
      1.upto(stop_count(table)).each do |stop_count|
        stop = make_stop(table.xpath("tbody[#{stop_count}]/tr/td[#{count}]")[0], stop_count - 1, direction)
        stops.push stop if stop
      end
      stops
    end

    def find_table(args)
      @tables.find { |t|
        t[:direction] == args[:direction] && t[:schedule] == args[:schedule]
      }[:tables][args[:table]-1]
    end

    def find_node(table, args)
      table.xpath("tbody[#{args[:row]}]/tr/td[#{args[:column]}]").first
    end

    def sanitize(input)
      input.delete_at(0) if input.is_a?(Array)
      input
    end

  end
end
