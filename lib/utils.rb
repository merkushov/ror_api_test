require 'uri'

class Utils
  def self.convert_links_to_domains(links)
    unless links.kind_of?(Array)
      raise ArgumentError, "the first argument must be an array"
    end

    domains = []

    links.each do |link|
      uri = URI.parse(link)
      uri.normalize

      if uri.absolute?
        domains.push(uri.host)
      else
        domains.push(link)
      end
    end

    domains
  end
end