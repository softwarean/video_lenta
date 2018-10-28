module BroadcastingReportBuilder
  module CameraAvailabilityCalculator
    class << self
      def calculate(first_timestamp, last_timestamp, timestamps)
        requested_array = timestamps.select {|t| (first_timestamp..last_timestamp).include?(t)}

        original_timestamp_count = ((last_timestamp - first_timestamp) / 60.0).ceil + 1

        "#{percent(requested_array.count, original_timestamp_count)}% (#{requested_array.count}/#{original_timestamp_count})"
      end

      def percent(received_count, original_count)
        (received_count.to_f * 100 / original_count.to_f).round
      end
    end
  end
end
