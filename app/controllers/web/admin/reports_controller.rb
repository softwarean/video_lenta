class Web::Admin::ReportsController < Web::Admin::ApplicationController
  authorize_actions_for Report

  def index
  end

  def show
    @report = Report.actual.find(params[:id])
    send_file @report.file.path, type: :csv
  end

  def create
    report = Report.create
    Resque.enqueue(GenerateReportJob, report.id)
    redirect_to admin_reports_path
  end

  def destroy
    @report = Report.actual.find(params[:id])
    @report.mark_as_deleted
    redirect_to admin_reports_path
  end
end
