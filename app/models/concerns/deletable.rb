module Concerns
  module Deletable
    extend ActiveSupport::Concern

    included do
      state_machine :state, initial: :actual do
        event(:mark_as_deleted) { transition actual: :deleted }
        event(:restore) { transition deleted: :actual }
      end

      scope :actual, -> { with_state :actual }
    end
  end
end
