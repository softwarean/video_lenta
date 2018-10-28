module BroadcastingRepository
  extend ActiveSupport::Concern

  included do
    scope :active, -> { with_state :active }
    scope :inactive, -> { with_state :inactive }
  end
end
