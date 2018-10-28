module DistrictRepository
  extend ActiveSupport::Concern

  included do
    scope :published, -> { includes(:buildings).where(buildings: {state: 'published'}) }
  end
end
