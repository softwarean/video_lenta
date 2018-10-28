class Web::Admin::BuildingsController < Web::Admin::ApplicationController
  before_action :set_building, only: [:show, :edit, :monitoring, :update, :destroy]

  def index
    @q = current_user.available_buildings.search(params[:q])
    @buildings = @q.result.includes(:district, :broadcasting, district: :region).order(id: :desc).decorate
  end

  def new
    @building = BuildingType.new
    @broadcasting = @building.build_broadcasting
  end

  def monitoring
    @broadcasting = @building.broadcasting.decorate
    root_timezone = ActiveSupport::TimeZone.new('Europe/Moscow').utc_offset / 60
    gon.push({
               player_path: PlayerUriFormatter.folder_uri(@broadcasting.slug),
               timezone: @broadcasting.timezone_offset,
               root_timezone: root_timezone
             })
  end

  def edit
    @building = @building.becomes BuildingType
    @broadcasting = @building.broadcasting
    authorize_action_for @building
    gon.push({
               timezone_offset: @building.district.region.timezone_offset,
               camera_type: @broadcasting.camera_type,
               camera_enabled: @broadcasting.poll_camera
             })
  end

  def create
    @building = BuildingType.new(building_params)
    authorize_action_for @building
    @building.changed_by = current_user

    if @building.save
      redirect_to admin_buildings_path, notice: 'Building was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize_action_for @building
    @building = @building.becomes BuildingType
    @building.changed_by = current_user

    if @building.update(building_params)
      redirect_to admin_buildings_path, notice: 'Building was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize_action_for @building
    @building.changed_by = current_user

    @building.destroy
    redirect_to admin_buildings_url, notice: 'Building was successfully destroyed.'
  end

  private

  def set_building
    @building = Building.find(params[:id])
  end

  def building_params
    params.require(:building)
  end
end
