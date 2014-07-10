class UsersController < ApplicationController
  #action happens before the edit or the update command
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,   only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def show
  	# @user = User.find_by(params[:email])
  	# @user = user.authenticate(params[:password])
  	# if @user.nil?
  	# render 'signin'
  	#
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
      flash.now[:error] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Saved Changes!"
      redirect_back_or(@user)
    else
      render 'edit'
    end
  end

  def destroy
      @user = User.find(params[:id])
      if (!current_user?(@user))
        @user.destroy
        flash[:success] = "User deleted"
      else
        flash[:error] = "Sorry, can't delete yourself"
      end
      redirect_to users_url
  end

  private

  def user_params
  	return params.require(:user).permit(:name, :email, :password, 
  		:password_confirmation)
  end

  def signed_in_user
    if !signed_in?
      flash[:notice] = "Please sign in."
      store_location
      redirect_to signin_url
    end
  end

  def correct_user
    if current_user?(User.find(params[:id]))
      @user = current_user
    else
      redirect_to root_url
    end
  end

  def admin_user
    if !current_user.admin?
      flash[:notice] = "You don't have permissions to do that"
      redirect_to root_url
    end
  end
end
