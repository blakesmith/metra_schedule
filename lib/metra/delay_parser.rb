require 'nokogiri'
require 'open-uri'

module MetraSchedule
  class DelayParser
    attr_reader :html_doc
    attr_accessor :line

    def initialize(html_doc)
      @html_doc = html_doc
    end

    def scrape
      parse_nokogiri
      make_train_delays
    end

    def parse_nokogiri
      html_doc = open(@html_doc) if @html_doc.is_a?(String)
      html_doc = @html_doc if @html_doc.is_a?(File)
      @html_doc = Nokogiri::HTML(html_doc)
    end

    def make_train_delays
    end

    def find_train_num(node)
      node.text.scan(/#([0-9]+)/).first.first.to_i
    end
    
    def find_delay_range(node)
      match = node.text.scan(/([0-9]+) - ([0-9]+)/)
      (match.first[0].to_i..match.first[1].to_i)
    end

  end
end
