class BorrowerPortfolioController < ApplicationController
  def show
    @borrower = current_user
  end
end
