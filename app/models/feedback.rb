class Feedback < ActiveRecord::Base
  serialize :user_data

  validates :reason, presence: true
  validates :text, presence: true

  extend Enumerize

  enumerize :reason, in: [:broadcast_quality, :player_issues, :address_mistake, :description_mistake]
end
