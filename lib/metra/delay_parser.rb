require 'nokogiri'
require 'open-uri'

module MetraSchedule
  class DelayParser
    attr_reader :html_doc, :url
    attr_accessor :line

    def initialize(html_doc=nil)
      time = Time.now.to_i
      @url = "http://metrarail.com/content/metra/en/home/service_updates/service_updates_alerts/jcr:content/serviceAdvisory.display.html?t=#{time}"
      @html_doc = @url unless html_doc
      @html_doc = html_doc if html_doc
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
      return unless has_delays?
      all_advisories.inject([]) do |total, node|
        total << {:train_num => find_train_num(node), :delay => find_delay(node)}
      end
    end

    def find_train_num(node)
      node.text.scan(/#([0-9]+)/).first.first.to_i
    end

    def find_delay(node)
      text_array = node.text.delete("\r\n").split("\s")[3..-1]
      text_array.delete_at(0) if text_array[0] == "-"
      text_array.join("\s").strip
    end
    
    def has_delays?
      @html_doc.css('#serviceAdvisory').count > 0
    end

    private

    def all_advisories
      nodes = @html_doc.css('#serviceAdvisory dl dd')
      advisories = nodes.inject([]) do |total, node|
        id = node.attributes.has_key?("id")
        total << node unless id
        total
      end
    end

  end
end
