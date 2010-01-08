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

  def test_find_delay_range
    node = advisory_alert_stub.html_doc.css('#serviceAdvisory')
    assert_equal((18..20), advisory_alert_stub.find_delay_range(node))
  end

  def test_make_train_delays
    assert_equal([{:train_num => 2156, :delay => (18..20)}], advisory_alert_stub.make_train_delays)
  end

  def test_has_delays?
    assert_equal(true, advisory_alert_stub.has_delays?)
    assert_equal(false, no_advisory_stub.has_delays?)
  end

end
