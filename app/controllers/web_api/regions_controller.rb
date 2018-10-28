class WebApi::RegionsController < WebApi::ApplicationController
  def index
    regions = Region.published.order(name: :asc)
    respond_with regions
  end
end
