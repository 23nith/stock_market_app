class UsersController < ApplicationController
  # skip_before_action :verify_authenticity_token, :only => [:approve_user]
  # protect_from_forgery with: :null_session

  def index
    if current_user.role == "admin"
      @users = User.order(params[:sort])
      @arr = []
      @users.each do |user|
        @arr.push({:id => user.id, 
          :email => user.email,
          :role => user.role,
          :created_at => user.created_at,
          :updated_at => user.updated_at,
          :jti => user.jti, 
          :balance => user.balance,
          :first_name => user.first_name,
          :last_name => user.last_name,
          :confirmed_at => user.confirmed_at
        })
      end
      # puts "TESTING!!!!!!!!!!!!! #{@arr}"
      # render json: @users
      render json: @arr
    else
      render json: {
        status: {code: 401, message: 'You have no sufficient priviledges to access this route.'},
      }
    end
    
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def edit
    @user = User.find(params[:id])
    @user.update(email: params[:email])
    @user.confirmed_at = DateTime.now
    @user.skip_confirmation!
    @user.update(password: params[:password])
    @user.update(first_name: params[:first_name])
    @user.update(last_name: params[:last_name])
    if @user.save!
      render json: {
        status: {code: 200, message: "User has been edited."},
      }
    end
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

  # def approve_user
  #   # debugger
  #   @user = User.find(params[:id])
  #   @user.confirmed_at = DateTime.now
  #   if @user.save!
  #     render json: {
  #       status: {code: 200, message: 'User has been approved.'},
  #     }
  #   end

  # end

  
  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end


end
