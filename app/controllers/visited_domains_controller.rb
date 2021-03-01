require 'utils'

class VisitedDomainsController < ApplicationController
  def add_links
    epoch_time = Time.now.to_i

    if params[:links] and params[:links].kind_of?(Array)
      domains = Utils.convert_links_to_domains( params[:links] )

      VisitedDomain.add_list(epoch_time, domains)
      render json: { "status": "ok" }
    else
      render json: { "status": "Validation failed: the 'links' parameters is required and must be an Array" },
             status: :unprocessable_entity
    end
  end

  def show_domains
    from  = params[:from]
    to    = params[:to]

    if from and to
      domains = VisitedDomain.show(from, to)
      render json: { "status": "ok", "domains": domains }
    else
      render json: { "status": "Validation failed: parameters 'from' and 'to' are required" },
             status: :unprocessable_entity
    end
  end
end