class WebApi::DistrictsController < WebApi::ApplicationController
  def index
    districts = District.published.order(name: :asc)
    respond_with districts
  end
end
