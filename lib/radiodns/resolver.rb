require 'resolv'

class RadioDNS::Resolver
  @root_domain = 'radiodns.org'

  class << self
    attr_accessor :root_domain

    def resolve(fqdn)
      if fqdn.is_a? Hash
        fqdn = construct_fqdn(fqdn)
      end

      resolver = Resolv::DNS.new
      cname = resolver.getresource(fqdn, Resolv::DNS::Resource::IN::CNAME)
      RadioDNS::Service.new(cname.name.to_s)
    end

    def construct_fqdn(params)
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
    def construct_fqdn_for_hd(params)
      raise ArgumentError unless params[:tx] && params[:cc]
      [params[:tx], params[:cc], 'hd', root_domain].join('.')
    end

    def construct_fqdn_for_drm_or_amss(params)
      raise ArgumentError unless params[:sid]
      [params[:sid], params[:bearer], root_domain].join('.')
    end

    def construct_fqdn_for_dab(params)
      raise ArgumentError unless params[:scids] && params[:sid] && params[:eid] && params[:ecc]
      [params[:appty_uatype] || params[:pa],
       params[:scids],
       params[:sid],
       params[:eid],
       params[:ecc],
       'dab',
       root_domain].reject{|a| a.nil?}.join('.')
    end

    def construct_fqdn_for_fm(params)
      raise ArgumentError if params[:ecc] && params[:country]
      raise ArgumentError if params[:ecc].nil? && params[:country].nil?
      [params[:freq],
       params[:pi],
       params[:ecc] || params[:country],
       'fm',
       root_domain].join('.')
    end
  end
end
