class Web::Admin::SessionsController < Web::Admin::ApplicationController
  skip_before_action :redirect_if_user_is_not_authorized, only: [:new, :create]

  def new
    @session = SignInType.new
  end

  def create
    @session = SignInType.new(session_params)

    if @session.valid?
      user = @session.user
      sign_in user
      redirect_to :admin_root
    else
      render :new
    end
  end

  def destroy
    sign_out

    redirect_to new_admin_session_path
  end

  private

  def session_params
    params.require(:session)
  end
end
