class ApplicationController < ActionController::Base
  include Concerns::Auth
  helper_method :current_user, :signed_in?
end
