class WebApi::BuildingsController < WebApi::ApplicationController
  def index
    q = Building.published.search(params[:q])
    buildings = q.result.includes(:district).order(name: :asc)
    respond_with buildings
  end

  def show
    building = Building.find(params[:id])
    respond_with building
  end
end
