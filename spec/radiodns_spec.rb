gem 'minitest'
require 'minitest/autorun'
require 'mocha'
require 'radiodns'

describe "RadioDNS::Resolver" do
  describe "resolve" do
    it "should query radiodns.org" do
      mock_resolver = mock()
      mock_resolver.expects(:getname).
        with('09580.c586.ce1.fm.radiodns.org', Resolv::DNS::Resource::IN::CNAME).once.
        returns('rdns.musicradio.com')

      Resolv::DNS.expects(:new).returns(mock_resolver)

      cname = RadioDNS::Resolver.resolve('09580.c586.ce1.fm.radiodns.org')
      assert_equal 'rdns.musicradio.com', cname
    end
  end
end
