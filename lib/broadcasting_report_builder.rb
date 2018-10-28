require 'csv'

module BroadcastingReportBuilder
  class << self
    def build_file
      report_file_name = PathHelper.report_path
      CSV.open(report_file_name, "w:windows-1251", col_sep: ';') do |csv|
        csv << report_date()
        csv << report_head()

        Broadcasting.find_each do |broadcasting|
          data = broadcasting_data(broadcasting)
          csv << data if data
        end
      end

      report_file_name
    end

    def build
      Rails.logger.info "Building cameras report"

      csv_string = CSV.generate do |csv|
        csv << report_date()
        csv << report_head()

        Broadcasting.find_each do |broadcasting|
          data = broadcasting_data(broadcasting)
          csv << data if data
        end
      end

      csv_string
    end

    def broadcasting_data(broadcasting)
      broadcasting_data = []
      broadcasting_data << broadcasting.building.id
      broadcasting_data << broadcasting.camera_type

      index_json = CameraJsonSource.get_json(broadcasting)
      if index_json.nil?
        broadcasting_data += nodata()
        return broadcasting_data
      end

      first_timestamp = index_json["first"]

      timezone_offset = timezone_offset_for(broadcasting)

      first_frame_time = frame_time(first_timestamp, timezone_offset)

      broadcasting_data << first_frame_time

      current_timestamp = Time.now.utc.to_i + timezone_offset

      timestamps = get_timestamps(broadcasting, first_timestamp, current_timestamp)

      broadcasting_data << availability_for(1.hour.ago.utc.to_i + timezone_offset, current_timestamp, timestamps)
      broadcasting_data << availability_for(1.day.ago.utc.to_i + timezone_offset, current_timestamp, timestamps)
      broadcasting_data << availability_for(first_timestamp, current_timestamp, timestamps)

      broadcasting_data
    end

    def get_timestamps(broadcasting, first_timestamp, last_timestamp)
      timestamps = []
      date_range = (Time.at(first_timestamp).to_date..Time.at(last_timestamp).to_date)
      date_range.each do |day|
        data = CameraJsonSource.get_json_for_date(broadcasting, day)
        if data
          timestamps.concat(data["listing"])
        end
      end
      timestamps.uniq
    end

    def availability_for(start_timestamp, last_timestamp, timestamps)
      BroadcastingReportBuilder::CameraAvailabilityCalculator.calculate(start_timestamp, last_timestamp, timestamps)
    end

    def report_date
      ["Дата создания отчёта", Time.now.in_time_zone("Moscow").to_s(:report)]
    end

    def report_head
      ["ID камеры", "Тип камеры", "Дата и время первой сохранённой минуты", "За последний час", "За последние 24 часа", "За всё время"]
    end

    def nodata
       ["Не удалось получить данные"] + [nil]*3
    end

    def timezone_offset_for(broadcasting)
      if broadcasting.camera_type.ftp?
        broadcasting.building.district.region.timezone_offset.minutes
      else
        0
      end
    end

    def frame_time(timestamp, timezone_offset)
      Time.at(timestamp - timezone_offset).in_time_zone("Moscow").to_s(:report)
    end
  end
end
