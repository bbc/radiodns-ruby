gem 'minitest'
require 'minitest/autorun'
require 'mocha'
require 'radiodns'

describe "RadioDNS::Service" do
  before(:each) do
    @service = RadioDNS::Service.new('rdns.musicradio.com')
  end

  it "has a cname" do
    assert @service.respond_to? :cname
  end

  it "looks up radiovis application" do
    @service.expects(:application).with(:radiovis).returns(nil)
    @service.radiovis
  end

  it "looks up radiotag application" do
    @service.expects(:application).with(:radiotag).returns(nil)
    @service.radiotag
  end

  it "looks up radioepg application" do
    @service.expects(:application).with(:radioepg).returns(nil)
    @service.radioepg
  end

  it "has an array of supported applications" do
    @service.expects(:application).with(:radioepg).returns(:epg)
    @service.expects(:application).with(:radiovis).returns(:vis)
    @service.expects(:application).with(:radiotag).returns(:tag)
    assert_equal [:tag, :epg, :vis], @service.applications
  end

  it "performs SVR lookups" do
    mock_resolver = mock()
    mock_resource = mock()
    mock_resolver.expects(:getresource).
      with('_some_application._tcp.rdns.musicradio.com', Resolv::DNS::Resource::IN::SRV).once.
      returns(mock_resource)
    mock_resource.expects(:port).returns(1234)
    Resolv::DNS.expects(:new).returns(mock_resolver)

    application = @service.application(:some_application)

    assert_equal "rdns.musicradio.com", application.host
    assert_equal 1234, application.port
  end

  it "returns nil when lookup fails" do
    mock_resolver = mock()
    mock_resource = mock()
    mock_resolver.expects(:getresource).
      with('_some_application._tcp.rdns.musicradio.com', Resolv::DNS::Resource::IN::SRV).once.
      raises(Resolv::ResolvError)
    Resolv::DNS.expects(:new).returns(mock_resolver)

    application = @service.application(:some_application)
    assert application.nil?
  end
end

describe "RadioDNS::Resolver" do
  describe "resolve" do
    before(:each) do
      mock_resolver = mock()
      mock_cname = mock()
      mock_resolver.expects(:getresource).
        with('09580.c586.ce1.fm.radiodns.org', Resolv::DNS::Resource::IN::CNAME).once.
        returns(mock_cname)
      mock_cname.expects(:name).returns('rdns.musicradio.com')

      Resolv::DNS.expects(:new).returns(mock_resolver)
    end
    it "should query radiodns.org" do
      service = RadioDNS::Resolver.resolve('09580.c586.ce1.fm.radiodns.org')
      assert_equal 'rdns.musicradio.com', service.cname
    end

    it "should accept hash params too" do
      params = {
        :freq => '09580',
        :pi => 'c586',
        :ecc => 'ce1',
        :bearer => 'fm'
      }
      service = RadioDNS::Resolver.resolve(params)
      assert_equal 'rdns.musicradio.com', service.cname
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
    describe "for DAB bearer" do
      it "should construct a fqdn" do
        params = {
          :bearer => 'dab',
          :ecc => 'ecc',
          :eid => 'eid',
          :sid => 'sid',
          :scids => 'scids'
        }
        fqdn = RadioDNS::Resolver.construct_fqdn(params)
        assert_equal 'scids.sid.eid.ecc.dab.radiodns.org', fqdn
      end
      it "should raise if parameters are missing" do
        params = {
          :bearer => 'dab',
        }
        assert_raises(ArgumentError) {RadioDNS::Resolver.construct_fqdn(params)}
      end
      it "should prepend appty-uatype if provided" do
        params = {
          :bearer => 'dab',
          :ecc => 'ecc',
          :eid => 'eid',
          :sid => 'sid',
          :scids => 'scids',
          :appty_uatype => 'appty-uatype'
        }
        fqdn = RadioDNS::Resolver.construct_fqdn(params)
        assert_equal 'appty-uatype.scids.sid.eid.ecc.dab.radiodns.org', fqdn
      end
      it "should prepend pa if provided" do
        params = {
          :bearer => 'dab',
          :ecc => 'ecc',
          :eid => 'eid',
          :sid => 'sid',
          :scids => 'scids',
          :pa => 'pa'
        }
        fqdn = RadioDNS::Resolver.construct_fqdn(params)
        assert_equal 'pa.scids.sid.eid.ecc.dab.radiodns.org', fqdn
      end
    end
    describe "for DRM bearer" do
      it "should construct a fqdn" do
        params = {
          :bearer => 'drm',
          :sid => 'sid',
        }
        fqdn = RadioDNS::Resolver.construct_fqdn(params)
        assert_equal 'sid.drm.radiodns.org', fqdn
      end
      it "should raise if sid is missing" do
        params = {
          :bearer => 'drm',
        }
        assert_raises(ArgumentError) {RadioDNS::Resolver.construct_fqdn(params)}
      end
    end
    describe "for AMSS bearer" do
      it "should construct a fqdn" do
        params = {
          :bearer => 'amss',
          :sid => 'sid',
        }
        fqdn = RadioDNS::Resolver.construct_fqdn(params)
        assert_equal 'sid.amss.radiodns.org', fqdn
      end
      it "should raise if sid is missing" do
        params = {
          :bearer => 'amss',
        }
        assert_raises(ArgumentError) {RadioDNS::Resolver.construct_fqdn(params)}
      end
    end
    describe "for hd bearer" do
      it "should construct a fqdn" do
        params = {
          :bearer => 'hd',
          :tx => 'tx',
          :cc => 'cc',
        }
        fqdn = RadioDNS::Resolver.construct_fqdn(params)
        assert_equal 'tx.cc.hd.radiodns.org', fqdn
      end
      it "should raise if tx or cc is missing" do
        params = {
          :bearer => 'hd',
        }
        assert_raises(ArgumentError) {RadioDNS::Resolver.construct_fqdn(params)}
      end
    end
  end
end
