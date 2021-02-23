class Utils
  def self.convert_links_to_domains(links)
    unless links and links.kind_of?(Array)
      return
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