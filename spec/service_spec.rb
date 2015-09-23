$:.unshift(File.dirname(__FILE__))

require 'spec_helper'


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
    mock_resolver.expects(:getresource)
      .with('_some_application._tcp.rdns.musicradio.com', Resolv::DNS::Resource::IN::SRV)
      .once
      .returns(mock_resource)
    mock_resource.expects(:port).returns(1234)
    mock_resource.expects(:target).returns("rdns.musicradio.com")
    Resolv::DNS.expects(:new).returns(mock_resolver)

    application = @service.application(:some_application)

    assert_equal "rdns.musicradio.com", application.host
    assert_equal 1234, application.port
  end

  it "performs SRV lookups" do
    mock_resolver = mock()
    mock_resource = mock()
    mock_resolver.expects(:getresource)
      .with('_some_application._tcp.rdns.musicradio.com', Resolv::DNS::Resource::IN::SRV)
      .once
      .returns(mock_resource)
    mock_resource.expects(:port).returns(1234)
    mock_resource.expects(:target).returns("rdns.musicradio.com")
    Resolv::DNS.expects(:new).returns(mock_resolver)

    application = @service.application(:some_application)

    assert_equal "rdns.musicradio.com", application.host
    assert_equal 1234, application.port
  end

  it "returns nil if an SRV record is not present" do
    mock_resolver = mock()

    mock_resolver.expects(:getresource)
      .with('_unknown_application._tcp.rdns.musicradio.com', Resolv::DNS::Resource::IN::SRV)
      .once
      .raises(Resolv::ResolvError)
    Resolv::DNS.expects(:new).returns(mock_resolver)

    application = @service.application(:unknown_application)
    assert_equal nil, application
  end
end
