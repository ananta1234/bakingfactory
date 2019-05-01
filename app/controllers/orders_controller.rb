class OrdersController < ApplicationController

  include AppHelpers::Baking
  include AppHelpers::Shipping

  before_action :set_order, only: [:show, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
    if logged_in? && ( current_user.role?(:admin))
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(10)
    elsif logged_in? && ( current_user.role?(:baker))
      @bread_baking_list = create_baking_list_for("bread")
      @muffin_baking_list = create_baking_list_for("muffin")
      @pastry_baking_list = create_baking_list_for("pastries")
    elsif logged_in? && ( current_user.role?(:shipper))
      @unshipped_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(10)
      @shipped_orders = Order.shipped.chronological.paginate(:page => params[:page]).per_page(10)
    else
      @current_customer = current_user.customer
      @customer_orders = @current_customer.orders
    end
  end

  def show
    @previous_orders = @order.customer.orders.chronological.to_a
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.date = Date.current
    if @order.save
      @order.pay
      redirect_to @order, notice: "Thank you for ordering from the Baking Factory."
    else
      render action: 'new'
    end
  end
  

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id, :customer_id, :grand_total)
  end

end