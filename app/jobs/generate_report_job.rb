class GenerateReportJob
  @queue = :reports

  class << self
    def perform(report_id)
      Rails.logger.info("Generating report ##{report_id}")
      report = Report.find(report_id)
      report.process
      begin
        file_name = BroadcastingReportBuilder.build_file
        report.file = File.open(file_name)
        report.save!
      rescue
        report.fall
        Rails.logger.info("Report ##{report_id} generating failed")
        return
      end
      report.complete
      Rails.logger.info("Report ##{report_id} generated")
    end
  end
end
