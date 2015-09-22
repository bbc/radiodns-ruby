require 'resolv'

module RadioDNS
  class Service
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

    def application(service)
      resolver = Resolv::DNS.new

      prefix = "_#{service.to_s}._tcp."
      host = prefix + cname
      resource = resolver.getresource(host, Resolv::DNS::Resource::IN::SRV)
      Application.new :host => resource.target.to_s, :port => resource.port, :type => service
    end
  end

  class Application
    attr_accessor :host, :port, :type
    def initialize(params)
      @host = params[:host]
      @port = params[:port]
      @type = params[:type]
    end
  end

  class Resolver
    def self.resolve(fqdn)
      if fqdn.is_a? Hash
        fqdn = construct_fqdn(fqdn)
      end

      resolver = Resolv::DNS.new
      cname = resolver.getresource(fqdn, Resolv::DNS::Resource::IN::CNAME)
      Service.new(cname.name.to_s)
    end

    def self.construct_fqdn(params)
      bearer = params[:bearer]
      case bearer
        when "fm" then construct_fqdn_for_fm(params)
        when "dab" then construct_fqdn_for_dab(params)
        when "drm" then construct_fqdn_for_drm_or_amss(params)
        when "amss" then construct_fqdn_for_drm_or_amss(params)
        when "hd" then construct_fqdn_for_hd(params)
      end
    end

    private
    def self.construct_fqdn_for_hd(params)
      raise ArgumentError unless params[:tx] && params[:cc]
      [params[:tx], params[:cc], 'hd.radiodns.org'].join('.')
    end
    def self.construct_fqdn_for_drm_or_amss(params)
      raise ArgumentError unless params[:sid]
      [params[:sid], params[:bearer], 'radiodns.org'].join('.')
    end
    def self.construct_fqdn_for_dab(params)
      raise ArgumentError unless params[:scids] && params[:sid] && params[:eid] && params[:ecc]
      [params[:appty_uatype] || params[:pa],
       params[:scids],
       params[:sid],
       params[:eid],
       params[:ecc],
       'dab.radiodns.org'].reject{|a| a.nil?}.join('.')
    end
    def self.construct_fqdn_for_fm(params)
      raise ArgumentError if params[:ecc] && params[:country]
      raise ArgumentError if params[:ecc].nil? && params[:country].nil?
      [
        case params[:freq]
          when String
            params[:freq]
          when Float
            sprintf("%05d", params[:freq] * 100)
          else
            raise ArgumentError
        end,
        params[:pi],
        params[:ecc] || params[:country],
        'fm.radiodns.org'
      ].join('.')
    end
  end
end
