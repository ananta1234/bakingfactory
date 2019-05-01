  class ItemPricesController < ApplicationController
  before_action :check_login
  before_action :set_item_price

  authorize_resource

  def new
    @item_price = ItemPrice.new
  end

  def create
    @item_price = ItemPrice.new(item_price_params)
    if @item_price.save
      redirect_to @item, notice: "#{@item_price.name} was added to the system."
    else
      render action: 'new'
    end
  end

  private
  def set_item_price
    @item_price = ItemPrice.find(params[:id])
  end

  def item_price_params
    params.require(:item_price).permit(:item_id, :price, :start_date, :end_date)
  end

end