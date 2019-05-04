class OrdersController < ApplicationController

  include AppHelpers::Shipping

  before_action :set_order_item, only: [:show, :destroy]
  before_action :check_login
  authorize_resource

  private
  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def order_item_params
    params.require(:order_item).permit(:order_id, :item_id, :shipped_on)
  end

end