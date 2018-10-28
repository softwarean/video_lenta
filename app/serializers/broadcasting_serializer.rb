class BroadcastingSerializer < ActiveModel::Serializer
  attributes :id, :state, :slug, :status, :last_frame_time

  def last_frame_time
    object.last_frame_time.to_i
  end
end
