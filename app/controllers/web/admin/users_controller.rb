class Web::Admin::UsersController < Web::Admin::ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  authorize_actions_for User

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = UserType.new(user_params)
    @user.changed_by = current_user

    if @user.save
      redirect_to admin_users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    @user = @user.becomes UserType
    @user.changed_by = current_user

    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.changed_by = current_user
    @user.destroy
    redirect_to admin_users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user)
  end
end
