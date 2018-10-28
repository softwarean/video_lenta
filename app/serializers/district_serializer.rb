class DistrictSerializer < ActiveModel::Serializer
  attributes :id, :name, :localities

  def localities
    object.buildings.published.pluck(:locality)
  end
end
