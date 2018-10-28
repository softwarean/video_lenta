class RegionSerializer < ActiveModel::Serializer
  attributes :id, :name, :osm_id
  has_many :districts

  def districts
    object.districts.published.order(name: :asc)
  end
end
