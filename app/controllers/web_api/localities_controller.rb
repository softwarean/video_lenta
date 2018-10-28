class WebApi::LocalitiesController < WebApi::ApplicationController
  def index
    @localities = Building.published.pluck(:locality).uniq
  end
end
