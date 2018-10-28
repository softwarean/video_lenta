class ReportSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :human_queue_state_name, :queue_state

  def created_at
    object.created_at.to_s(:report)
  end
end
