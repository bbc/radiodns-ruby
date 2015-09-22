class RadioDNS::Application
  attr_accessor :host, :port, :type
  def initialize(params)
    @host = params[:host]
    @port = params[:port]
    @type = params[:type]
  end
end

