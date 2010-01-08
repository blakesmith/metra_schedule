require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestDelayParser < Test::Unit::TestCase
  include MetraSchedule::TrainData

  def advisory_alert_stub
    f = File.open(File.join(File.dirname(__FILE__), '../fixture/service_updates_alerts.html'), 'r')
    parser = MetraSchedule::DelayParser.new f
    parser.scrape
    parser
  end

  def no_advisory_stub
    f = File.open(File.join(File.dirname(__FILE__), '../fixture/service_updates_alerts_no_advisories.html'), 'r')
    parser = MetraSchedule::DelayParser.new f
    parser.scrape
    parser
  end

  def no_range_stub
    f = File.open(File.join(File.dirname(__FILE__), '../fixture/service_updates_alerts_no_range.html'), 'r')
    parser = MetraSchedule::DelayParser.new f
    parser.scrape
    parser
  end

  def no_delay_advisory
    f = File.open(File.join(File.dirname(__FILE__), '../fixture/service_updates_alerts_multiple_with_non_delay.html'), 'r')
    parser = MetraSchedule::DelayParser.new f
    parser.scrape
    parser
  end

  def test_init
    assert_nothing_raised do
      @@p = MetraSchedule::DelayParser.new 'http://blake.com'
    end
    assert_not_nil(advisory_alert_stub.html_doc)
    assert_not_nil(@@p.html_doc)
  end

  def test_find_train_num
    node = advisory_alert_stub.html_doc.css('#serviceAdvisory')
    assert_equal(2156, advisory_alert_stub.find_train_num(node))
  end

  def test_find_delay
    node = advisory_alert_stub.html_doc.css('#serviceAdvisory')
    assert_equal("20 minutes delayed", advisory_alert_stub.find_delay(node))
  end

  def test_make_train_delays
    assert_equal([{:train_num => 2156, :delay => "18 - 20 minutes delayed"}], advisory_alert_stub.make_train_delays)
  end

  def test_has_delays?
    assert_equal(true, advisory_alert_stub.has_delays?)
    assert_equal(false, no_advisory_stub.has_delays?)
  end

  def test_find_delay_no_range
    node = no_range_stub.html_doc.css('#serviceAdvisory dd.first')
    assert_equal("15 Minute Delay", no_range_stub.find_delay(node))
  end

  def test_find_delay
    node = advisory_alert_stub.html_doc.css('#serviceAdvisory dd.first')
    assert_equal("18 - 20 minutes delayed", advisory_alert_stub.find_delay(node))
  end

  def test_find_delay_advisory_with_no_delay
    node = no_delay_advisory.html_doc.css('#serviceAdvisory dd.first')
    assert_equal("Stopped North of Ashburn", no_delay_advisory.find_delay(node))
  end

end
