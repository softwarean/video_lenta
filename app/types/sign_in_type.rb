class SignInType
  include BaseTypeWithoutActiveRecord

  attribute :email, String
  attribute :password, String

  validates :email, presence: true
  validates :password, presence: true
  validates :user, presence: true
  validate :check_authenticate, if: :email

  def user
    ::User.find_by(email: email)
  end

  private

  def check_authenticate
    unless user.try(:authenticate, password)
      errors.add(:password, :user_or_password_invalid)
    end
  end
end
