module UserRepository
  extend ActiveSupport::Concern

  included do
    def available_regions
      if admin?
        Region.all
      else
        regions
      end
    end

    def available_buildings
      if admin?
        Building.all
      else
        buildings
      end
    end
  end
end
