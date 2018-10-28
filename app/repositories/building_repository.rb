module BuildingRepository
  extend ActiveSupport::Concern
  include UsefullScopes

  included do
    scope :includes_objects, -> { includes(:broadcasting, :region) }
    scope :published, -> { includes_objects.with_state :published }
    scope :unpublished, -> { with_state :unpublished }

    def nearby
      Building.within(configus.building.nearby_distance, origin: self).exclude(self)
    end
  end
end
