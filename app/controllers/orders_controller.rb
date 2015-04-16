class OrdersController < ApplicationController
  def create
    if current_user && current_user.lender?
      order = Order.new(cart_items: params[:cart], user_id: current_user.id)
      if order.save
        order.update_contributed(current_user)
        order.send_contributed_to_email
        flash[:notice] = "Thank you for your contribution, #{current_user.name}!"
        session[:cart] = {}
        redirect_to lender_path(current_user)
      else
        flash[:notice] = order.errors.full_messages.to_sentence
        redirect_to cart_path
      end
    else
      flash[:notice] = "Please Log In to Finalize Contribution"
      redirect_to cart_path
    end
  end
end
