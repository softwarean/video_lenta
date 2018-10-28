class ReportDecorator < Draper::Decorator
  delegate_all

  def created_at
    object.created_at.in_time_zone("Moscow")
  end
end
