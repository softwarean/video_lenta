class Building < ActiveRecord::Base
  belongs_to :district

  has_one :region, through: :district

  has_many :contractors, dependent: :destroy
  accepts_nested_attributes_for :contractors, reject_if: :all_blank, allow_destroy: true

  has_one :broadcasting, dependent: :destroy, inverse_of: :building
  accepts_nested_attributes_for :broadcasting, reject_if: :all_blank, allow_destroy: true

  has_many :documents, dependent: :destroy
  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true

  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :district, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :locality, presence: true
  validates :start_date, presence: true
  validates :finish_date, presence: true

  state_machine :state, initial: :published do
    event(:publish) { transition any => :published }
    event(:unpublish) { transition any => :unpublished }
  end

  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  audit :name, :state, :locality, :start_date, :finish_date, :description, :latitude, :longitude, :district_id, :broadcasting, :contractors

  include BuildingRepository

  include Authority::Abilities
end
