gem 'minitest'
require 'minitest/autorun'
require 'mocha'
require 'radiodns'

describe "RadioDNS::Resolver" do
  describe "resolve" do
    it "should query radiodns.org" do
      mock_resolver = mock()
      mock_cname = mock()
      mock_resolver.expects(:getresource).
        with('09580.c586.ce1.fm.radiodns.org', Resolv::DNS::Resource::IN::CNAME).once.
        returns(mock_cname)
      mock_cname.expects(:name).returns('rdns.musicradio.com')

      Resolv::DNS.expects(:new).returns(mock_resolver)

      cname = RadioDNS::Resolver.resolve('09580.c586.ce1.fm.radiodns.org')
      assert_equal 'rdns.musicradio.com', cname
    end
  end

  describe "construct_fqdn" do
    describe "for FM/VHF bearer" do
      it "should construct a fqdn when ecc is supplied" do
        params = {
          :bearer => 'fm',
          :ecc => 'ce1',
          :pi => 'c585',
          :freq => '09580'
        }
        fqdn = RadioDNS::Resolver.construct_fqdn(params)
        assert_equal '09580.c585.ce1.fm.radiodns.org', fqdn
      end
      it "should construct a fqdn when country is supplied" do
        params = {
          :bearer => 'fm',
          :country => 'gb',
          :pi => 'c585',
          :freq => '09580'
        }
        fqdn = RadioDNS::Resolver.construct_fqdn(params)
        assert_equal '09580.c585.gb.fm.radiodns.org', fqdn
      end
      it "should raise when country and ecc is supplied" do
        params = {
          :bearer => 'fm',
          :country => 'gb',
          :ecc => 'ce1',
          :pi => 'c585',
          :freq => '09580'
        }
        assert_raises(ArgumentError) {RadioDNS::Resolver.construct_fqdn(params)}
      end
      it "should raise when neither country nor ecc is supplied" do
        params = {
          :bearer => 'fm',
          :pi => 'c585',
          :freq => '09580'
        }
        assert_raises(ArgumentError) {RadioDNS::Resolver.construct_fqdn(params)}
      end
    end
  end
end
