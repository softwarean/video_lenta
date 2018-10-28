module CameraJsonSource
  class << self
    def get_json(broadcasting)
      url = index_file_url(broadcasting)

      json = download_json(url)

      parse_json(json)
    end

    def get_json_for_date(broadcasting, date)
      url = date_file_url(broadcasting, date)

      json = download_json(url)

      parse_json(json)
    end

    def download_json(url)
      uri = URI(url)
      Rails.logger.info "downloading camera json from #{uri}"
      if uri.relative?
        response = Net::HTTP.get('localhost', uri.to_s)
      else
        response = Net::HTTP.get(uri)
      end
    end

    def date_file_url(broadcasting, date)
      formatted_date = date.strftime("%Y/%m/%d")
      url = "#{configus.player.path}#{broadcasting.slug}/#{formatted_date}/#{configus.player.index_file}"
    end

    def index_file_url(broadcasting)
      url = "#{configus.player.path}#{broadcasting.slug}/#{configus.player.index_file}"
    end

    def parse_json(json)
      begin
        data = JSON.parse(json)
      rescue
        Rails.logger.info 'something went wrong'
        return nil
      end
    end
  end
end
