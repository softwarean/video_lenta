class BuildingType < Building
  include ActiveModel::Validations
  include ApplicationType

  permit :name, :state, :description, :start_date, :finish_date,
    :locality, :latitude, :longitude,
    :construction_type_id, :district_id,
    contractors_attributes: [:id, :name, :_destroy],
    broadcasting_attributes: [:id, :name, :camera_name, :camera_type, :slug, :url, :finish_datetime, :state, :poll_camera, :_destroy],
    documents_attributes: [:id, :name, :file, :_destroy],
    pictures_attributes: [:id, :name, :file, :_destroy]

  validates :latitude, "::Coordinate".to_sym => true
  validates :longitude, "::Coordinate".to_sym => true

  def longitude=(longitude)
    super(::CoordinateService.to_dd(longitude)) if longitude.present?
  end

  def latitude=(latitude)
    super(::CoordinateService.to_dd(latitude)) if latitude.present?
  end

end
