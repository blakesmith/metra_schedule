require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestDelayParser < Test::Unit::TestCase
  include MetraSchedule::TrainData

  def up_nw_stub
    f = File.open(File.join(File.dirname(__FILE__), '../fixture/service_updates_alerts.html'), 'r')
    parser = MetraSchedule::DelayParser.new f
    parser.scrape
    parser
  end

  def test_init
    assert_nothing_raised do
      @@p = MetraSchedule::DelayParser.new 'http://blake.com'
    end
    assert_not_nil(up_nw_stub.html_doc)
    assert_not_nil(@@p.html_doc)
  end

  def test_find_train_num
    node = up_nw_stub.html_doc.xpath('/html/body/div[2]/div[5]/div[2]/div/div[2]/div/dl/dd')
    assert_equal(815, up_nw_stub.find_train_num(node))
  end

  def test_find_delay_range
    node = up_nw_stub.html_doc.xpath('/html/body/div[2]/div[5]/div[2]/div/div[2]/div/dl/dd')
    assert_equal((15..20), up_nw_stub.find_delay_range(node))
  end

end
