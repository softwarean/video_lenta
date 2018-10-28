class Region < ActiveRecord::Base
  has_many :districts
  has_many :buildings, through: :districts
  has_many :user_regions
  has_many :users, through: :user_regions

  include RegionRepository
end
