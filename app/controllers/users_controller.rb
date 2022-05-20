class UsersController < ApplicationController
  def index
    @users = User.order(params[:sort])

    render json: @users
  end

  def new
    @user = User.new
  end

  def add_user
    @user = User.new(user_params)
    if current_user.role == "admin"
      @user.skip_confirmation!
    end
    if @user.save!
      redirect_to root_path
    end
  end

  def approve
    @user = User.find(params[:id])
    redirect_to root_path
  end

  def approve_user
    @user = User.find(params[:id])
    @user.confirmed_at = DateTime.now
    if @user.save!
      redirect_to root_path
    end

  end

  
  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
