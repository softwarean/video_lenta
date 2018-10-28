class User < ActiveRecord::Base
  include Authority::Abilities
  include Authority::UserAbilities

  include UserRepository

  has_secure_password
  has_many :user_regions
  has_many :regions, through: :user_regions
  has_many :buildings, through: :regions

  validates :email, presence: true

  extend Enumerize

  enumerize :role, in: [:admin, :moderator]

  audit :email, :role, :regions

  def admin?
    role.admin?
  end

  def guest?
    false
  end
end
