module Web::Admin::BroadcastingsHelper
  def camera_last_frame_time(broadcasting)

    if broadcasting.camera_type_is_ftp?
      timezone_offset = broadcasting.building.district.region.timezone_offset.minutes
      broadcasting.last_frame_time.utc - timezone_offset
    else
      broadcasting.last_frame_time.utc
    end

  end
end
