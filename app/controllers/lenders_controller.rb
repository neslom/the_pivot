class LendersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(lender_params.merge(role: "lender"))
    if user.save
      session[:user_id] = user.id
      flash[:notice] = "You've been saved"
      redirect_to lender_path(user)
    else
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to root_path
    end
  end

  def show
  end

  private

  def lender_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
