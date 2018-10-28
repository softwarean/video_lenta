class District < ActiveRecord::Base
  has_many :buildings
  belongs_to :region

  include DistrictRepository
end
