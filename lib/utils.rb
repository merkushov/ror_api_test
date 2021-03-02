require 'uri'

class Utils
  def self.convert_links_to_domains(links)
    unless links and links.kind_of?(Array)
      raise ArgumentError, "the 'links' parameters is required and must be an Array"
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