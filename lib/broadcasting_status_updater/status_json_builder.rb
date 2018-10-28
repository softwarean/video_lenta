module BroadcastingStatusUpdater
  module StatusJsonBuilder
    class << self
      def build
        uri = URI("#{configus.fetcher.path}#{configus.fetcher.index_file}")
        Rails.logger.info "downloading status.json from #{uri}"
        response = Net::HTTP.get(uri)
        JSON.parse(response)
      end
    end
  end
end
