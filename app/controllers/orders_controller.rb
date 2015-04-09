class OrdersController < ApplicationController
  def create
    if current_user && current_user.lender?
      order = Order.create(cart_items: params[:cart], user_id: current_user.id)
      order.update_contributed(current_user)
      flash[:notice] = "Thank you for your contribution, #{current_user.name}!"
      session[:cart] = {}
      redirect_to lender_path(current_user)
    else
      flash[:notice] = "Please Log In to Finalize Contribution"
      redirect_to cart_path
    end
  end

  def index
    if current_user && current_user.user?
      @orders = current_user.orders
    elsif current_user.admin?
      @orders = Order.all
    else
      flash[:notice] = "You Must Be Logged In"
      redirect_to login_path
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if params[:status] == "paid"
      @order.paid!
      redirect_to order_path
    elsif params[:status] == "cancelled"
      @order.cancelled!
      redirect_to order_path
    elsif params[:status] == "completed"
      @order.completed!
      redirect_to order_path
    end
  end
end
