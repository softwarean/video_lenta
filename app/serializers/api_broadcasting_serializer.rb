class ApiBroadcastingSerializer < ActiveModel::Serializer
  attributes :name, :camera_name, :url, :enabled, :building_id, :building_name, :camera_type

  def name
    object.slug
  end

  def enabled
    if object.camera_type.ftp? || object.status == :finished
      false
    else
      object.poll_camera
    end
  end

  def building_id
    object.building.id
  end

  def building_name
    object.building.name
  end
end
