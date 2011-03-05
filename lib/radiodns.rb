require 'resolv'

module RadioDNS
  class Resolver
    def self.resolve(fqdn)
      resolver = Resolv::DNS.new
      cname = resolver.getresource(fqdn, Resolv::DNS::Resource::IN::CNAME)
      cname.name.to_s
    end
  end
end
