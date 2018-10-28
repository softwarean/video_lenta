class BroadcastingDecorator < Draper::Decorator
  delegate_all

  def has_image?
    object.slug.present? && object.last_frame_time
  end

  def camera_type_is_ftp?
    object.camera_type == 'ftp'
  end

  def timezone_offset
    if object.camera_type == 'ftp'
      object.building.district.region.timezone_offset
    else
      0
    end
  end

  def last_frame_url
    timestamp = object.last_frame_time.utc
    "#{PlayerUriFormatter.folder_uri(object.slug)}#{timestamp.strftime("%Y/%m/%d")}/#{timestamp.to_i}.jpg"
  end

  def finish_datetime
    object.finish_datetime.to_i if object.finish_datetime
  end
end
