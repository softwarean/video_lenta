class Web::Admin::ApplicationController < Web::ApplicationController
  before_action :redirect_if_user_is_not_authorized
end
