require File.expand_path('../helper', __FILE__)

class HabitualistTest < Service::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new
  end

  def test_push
    @stubs.post "/webhooks/github/" do |env|
      assert_equal 'habitualist.com', env[:url].host
      data = Faraday::Utils.parse_query(env[:body])
      assert_equal 1, JSON.parse(data['payload'])['a']
      [200, {}, '']
    end

    svc = service({}, :a => 1)
    svc.receive_push
  end

  def service(*args)
    super Service::Habitualist, *args
  end
end

