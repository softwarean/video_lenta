class ReportAuthorizer < ApplicationAuthorizer
  class << self
    def default(able, user)
      !user.guest?
    end
  end
end
