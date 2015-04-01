class LendersController < ApplicationController
  def new
    @user = User.new(role: 0)
  end

  def create
    user = User.new(lender_params)
    if user.save
      session[:user_id] = user.id
      flash[:notice] = "You've been saved"
      redirect_to lender_path(user)
    else
      flash[:error] = "Something went wrong. Please try again"
      render :new
    end
  end

  def show

  end

  private

  def lender_params
    params.require(:user).permit(:name, :email, :password)
  end
end
