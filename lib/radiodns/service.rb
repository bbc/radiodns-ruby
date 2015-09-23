class RadioDNS::Service
  attr_accessor :cname
  def initialize(cname)
    @cname = cname
  end

  def radiovis
    application(:radiovis)
  end

  def radioepg
    application(:radioepg)
  end

  def radiotag
    application(:radiotag)
  end

  def applications
    applications = []
    [:radiotag, :radioepg, :radiovis].each do |method_name|
      application = self.send(method_name)
      applications << application if application
    end
    applications
  end

  def application(type)
    resolver = Resolv::DNS.new

    prefix = "_#{type}._tcp."
    host = prefix + cname

    begin
      resource = resolver.getresource(host, Resolv::DNS::Resource::IN::SRV)
      RadioDNS::Application.new(
        :host => resource.target.to_s,
        :port => resource.port,
        :type => type
      )
    rescue Resolv::ResolvError
      # Service not found
      nil
    end
  end
end
