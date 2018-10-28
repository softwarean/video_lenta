module Concerns
  module Auth
    def sign_out
      session[:user_id] = nil
    end

    def sign_in(user)
      session[:user_id] = user.id
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
      @current_user || GuestUser.new
    end

    def signed_in?
      !current_user.guest?
    end

    def redirect_if_user_is_not_authorized
      redirect_to new_admin_session_path unless signed_in?
    end
  end
end
