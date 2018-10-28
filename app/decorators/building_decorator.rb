class BuildingDecorator < Draper::Decorator
  delegate_all

  decorates_association :nearby
  decorates_association :broadcasting

  def region
    object.district.region.name if object.district
  end

  def district
    "#{object.district.name}" if object.district
  end

  def construction_type
    object.construction_type.name
  end

  def has_description?
    object.description.present?
  end

  def has_contractors?
    object.contractors.exists?
  end

  def nearby?
    object.nearby.exists?
  end

  def timezone
    object.district.region.timezone_offset
  end

  def show_broadcasting?
    object.broadcasting.active?
  end

  def status
    object.broadcasting.status
  end
end
