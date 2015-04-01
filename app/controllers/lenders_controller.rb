class LendersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user.create(role: 0)
  end
end
