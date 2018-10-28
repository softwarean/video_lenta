class AuditAuthorizer < ApplicationAuthorizer
  class << self
    def default(able, user)
      user.admin?
    end
  end
end
