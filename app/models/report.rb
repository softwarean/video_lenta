class Report < ActiveRecord::Base
  include Concerns::Deletable

  mount_uploader :file, ReportUploader

  state_machine :queue_state, initial: :queued do
    event(:process) { transition queued: :processing }
    event(:complete) { transition processing: :completed }
    event(:fall) { transition processing: :failed }
  end

  include Authority::Abilities
end
