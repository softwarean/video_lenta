class BuildingSerializer < ActiveModel::Serializer
  attributes :id, :name, :state, :latitude, :longitude, :region, :district, :locality, :start_date, :finish_date, :status, :last_frame_time, :slug, :broadcasting_finish_time, :camera_type

  def district
    object.district.name
  end

  def status
    object.broadcasting.status
  end

  def last_frame_time
    object.broadcasting.last_frame_time.to_i
  end

  def slug
    object.broadcasting.slug
  end

  def broadcasting_finish_time
    object.broadcasting.finish_datetime.to_i if object.broadcasting.finish_datetime
  end

  def camera_type
    object.broadcasting.camera_type
  end
end
