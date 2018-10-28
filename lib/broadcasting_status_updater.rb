module BroadcastingStatusUpdater
  class << self
    def update_by(source_type)
      data_source = "BroadcastingStatusUpdater::#{source_type.to_s.camelize}Builder".constantize

      data = data_source.build

      accumulated_timestamps = data.inject({}) do |accum, (slug, timestamp)|
        accum[timestamp] ||= []
        accum[timestamp] << slug
        accum
      end

      accumulated_timestamps.each do |timestamp, slugs|
        Broadcasting.where(slug: slugs).update_all(last_frame_time: Time.at(timestamp)) unless timestamp.zero?
      end
    end
  end
end
