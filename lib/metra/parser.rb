require 'nokogiri'
require 'open-uri'

module MetraSchedule
  class Parser
    attr_reader :html_doc, :tables

    def initialize(html_doc)
      html_doc = open(html_doc) if html_doc.is_a?(StringIO)
      html_doc = html_doc if html_doc.is_a?(File)
      @html_doc = Nokogiri::HTML(html_doc)
    end

    def scrape
      true
    end

    def seperate_tables
      tables = @html_doc.css('table.schedule')
      @tables = []
      @tables.push ({:schedule => :weekday, :direction => :inbound, :tables => tables[0..1]})
      @tables.push ({:schedule => :saturday, :direction => :inbound, :tables => tables[2]})
      @tables.push ({:schedule => :sunday, :direction => :inbound, :tables => tables[3]})
      @tables.push ({:schedule => :weekday, :direction => :outbound, :tables => tables[4..6]})
      @tables.push ({:schedule => :saturday, :direction => :outbound, :tables => tables[7]})
      @tables.push ({:schedule => :sunday, :direction => :outbound, :tables => tables[8]})
    end

  end
end
