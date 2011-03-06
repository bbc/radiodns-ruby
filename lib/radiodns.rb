require 'resolv'

module RadioDNS
  class Resolver
    def self.resolve(fqdn)
      resolver = Resolv::DNS.new
      cname = resolver.getresource(fqdn, Resolv::DNS::Resource::IN::CNAME)
      cname.name.to_s
    end

    def self.construct_fqdn(params)
      bearer = params[:bearer]
      case bearer
        when "fm" then construct_fqdn_for_fm(params)
      end
    end

    private
    def self.construct_fqdn_for_fm(params)
      raise ArgumentError if params[:ecc] && params[:country]
      raise ArgumentError if params[:ecc].nil? && params[:country].nil?
      [params[:freq],
       params[:pi],
       params[:ecc] || params[:country],
       params[:bearer],
       'radiodns.org'].join('.')
    end
  end
end
