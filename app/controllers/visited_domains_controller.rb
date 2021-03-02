require 'utils'

class VisitedDomainsController < ApplicationController

  # POST /visited_links
  def add_links
    epoch_time  = Time.now.to_i
    domains     = Utils.convert_links_to_domains( params[:links] )

    VisitedDomain.add_list(epoch_time, domains)
    render json: { "status": "ok" }
  end

  # GET /visited_domains
  def show_domains
    domains = VisitedDomain.show(params[:from], params[:to])
    render json: { "status": "ok", "domains": domains }
  end
end