$:.unshift(File.dirname(__FILE__))

require 'spec_helper'


describe "RadioDNS::Application" do
  before(:each) do
    @app = RadioDNS::Application.new(
      :host => 'radiovis.musicradio.com',
      :port => 6131,
      :type => :radiovis
    )
  end

  it "has a host" do
    assert_equal 'radiovis.musicradio.com', @app.host
  end

  it "has a port" do
    assert_equal 6131, @app.port
  end

  it "has a type" do
    assert_equal :radiovis, @app.type
  end
end
