class UsersController < ApplicationController
  before_action :set_user, only: [:update, :edit]
  before_action :require_current_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def edit
  end

  def show
  end

  def update
    if @user.update(user_params)
      flash[:success] = "User information changed successfully."
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "User has been created."
      redirect_to posts_path
    else
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :time_zone)
  end

  def set_user
    @user = User.find(session[:user_id])
  end
end