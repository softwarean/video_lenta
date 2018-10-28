class Web::BuildingsController < Web::ApplicationController
  before_action :set_building, only: [:show, :edit, :update, :destroy]

  def show
    @description = "#{@building.region}, #{@building.locality}, #{@building.district}"
  end

  private

  def set_building
    @building = Building.find(params[:id]).decorate
  end
end
