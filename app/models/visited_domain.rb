class VisitedDomain

  def self.add_list(timestamp, domains)
    unless timestamp and domains
      raise ArgumentError,
            "parameters 'timestamp' and 'domains' are required"
    end

    unless timestamp.is_a? Numeric
      raise ArgumentError,
            "parameter 'timestamp' must be numeric"
    end

    unless domains.kind_of?(Array)
      raise ArgumentError,
            "parameter 'domains' must be an array"
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

    unless from.is_a? Numeric and to.is_a? Numeric
      raise ArgumentError,
            "parameters 'from' and 'to' must be numeric"
    end

    REDIS_CLIENT.zrangebyscore(Rails.application.config.visited_domains_key, from, to)
  end
end