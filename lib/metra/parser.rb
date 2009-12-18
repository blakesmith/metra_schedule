require 'nokogiri'
require 'open-uri'

module MetraSchedule
  class Parser
    attr_reader :html_doc

    def initialize(html_doc)
      @html_doc = open(html_doc) if html_doc.is_a?(StringIO)
      @html_doc = html_doc if html_doc.is_a?(File)
      @html_doc = Nokogiri::HTML(@html_doc)
    end

#doc = Nokogiri::HTML(open(UP_NW))
#tables = doc.css('table.schedule')
#weekday_inbound = tables[0..1]
#saturday_inbound = tables[2]
#sunday_holiday_inbound = tables[3]
#weekday_outbound = tables[4..6]
#saturday_outbound = tables[7]
#sunday_holiday_outbound = tables[8]
#p tables.size

  end
end
