module RegionRepository
  extend ActiveSupport::Concern

  included do
    scope :published, -> { includes(districts: :buildings).where(buildings: {state: 'published'}) }
  end
end
