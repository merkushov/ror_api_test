require 'utils'

class VisitedDomainsController < ApplicationController
  def add_links
    epoch_time  = Time.now.to_i
    domains     = Utils.convert_links_to_domains( params[:links] )

    if VisitedDomain.add_list(epoch_time, domains)
      render json: { "status": "ok" }
    else
      render json: { "status": "error" }
    end
  end

  def show_domains
    from  = params[:from]
    to    = params[:to]

    if from and to
      domains = VisitedDomain.show(from, to)
      render json: { "status": "ok", "domains": domains }
    else
      render json: { "status": "Error: Params 'from' and 'to' are required" }
    end
  end
end