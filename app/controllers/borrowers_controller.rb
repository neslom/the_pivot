class BorrowersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(borrower_params.merge(role: "borrower"))
    if user.save
      session[:user_id] = user.id
      flash[:notice] = "You've been saved"
      redirect_to borrower_path(user)
    else
      flash[:error] = "Something went wrong. Please try again"
      render :new
    end
  end

  def show

  end

  private

  def borrower_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
