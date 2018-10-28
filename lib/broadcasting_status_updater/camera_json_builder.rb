module BroadcastingStatusUpdater
  module CameraJsonBuilder
    class << self
      def build
        data = {}
        Broadcasting.find_each do |broadcasting|
          json = CameraJsonSource.get_json(broadcasting)
          timestamp = json["last"] if json
          if timestamp && !timestamp.zero?
            data[broadcasting.slug] = timestamp
          end
        end

        data
      end
    end
  end
end
