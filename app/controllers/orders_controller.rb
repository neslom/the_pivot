class OrdersController < ApplicationController
  def create
    if current_user && current_user.lender?
      order = Order.create(cart_items: params[:cart], user_id: current_user.id)
      order.send_contributed_to_email
      order.update_contributed(current_user)
      flash[:notice] = "Thank you for your contribution, #{current_user.name}!"
      session[:cart] = {}
      redirect_to lender_path(current_user)
    else
      flash[:notice] = "Please Log In to Finalize Contribution"
      redirect_to cart_path
    end
  end
end
