class BuildingAuthorizer < ApplicationAuthorizer
  def creatable_by?(user)
    user.admin? || has_access?(user, resource)
  end

  def updatable_by?(user)
    user.admin? || has_access?(user, resource)
  end

  def deletable_by?(user)
    user.admin? || has_access?(user, resource)
  end

  def has_access?(user, building)
    user.regions.include? building.region
  end
end
