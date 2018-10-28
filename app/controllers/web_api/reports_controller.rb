class WebApi::ReportsController < WebApi::ApplicationController
  def index
    reports = Report.actual.order(id: :desc)
    respond_with reports
  end
end
