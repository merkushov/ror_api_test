class VisitedDomain

  def self.add_list(timestamp, domains)
    unless timestamp and domains and domains.kind_of?(Array)
      raise ArgumentError,
            "parameters 'timestamp' and 'domains' are required"
    end

    score_members = []
    domains.each do |domain|
      score_members.push(timestamp, domain)
    end
    REDIS_CLIENT.zadd(Rails.application.config.visited_domains_key, score_members)
  end

  def self.show(from, to)
    unless from and to
      raise ArgumentError,
            "parameters 'from' and 'to' are required"
    end

    REDIS_CLIENT.zrangebyscore(Rails.application.config.visited_domains_key, from, to)
  end
end