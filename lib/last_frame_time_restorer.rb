module LastFrameTimeRestorer
  class << self
    def restore_frame_time
      Broadcasting.find_each do |broadcasting|
        url = index_file_url(broadcasting)
        timestamp = get_last_timestamp(url)
        if timestamp && !timestamp.zero?
          broadcasting.update_attribute(:last_frame_time, Time.at(timestamp))
        end
      end
    end

    def index_file_url(broadcasting)
      url = "#{configus.player.path}#{broadcasting.slug}/#{configus.player.index_file}"
    end

    def get_last_timestamp(url)
      uri = URI(url)
      response = Net::HTTP.get(uri)
      begin
        json = JSON.parse(response)
        json["last"]
      rescue
        Rails.logger.info 'something went wrong'
        return nil
      end
    end
  end
end
