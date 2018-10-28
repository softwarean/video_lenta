class UserType < User
  include ApplicationType

  permit :email, :password, :password_confirmation, :role, region_ids: []
end
