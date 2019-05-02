class HomeController < ApplicationController

  include AppHelpers::Baking

  def home
    if logged_in? && ( current_user.role?(:admin))

    elsif logged_in? && ( current_user.role?(:baker))
      @bread_baking_list = create_baking_list_for("bread")
      @muffin_baking_list = create_baking_list_for("muffin")
      @pastry_baking_list = create_baking_list_for("pastries")
    elsif logged_in? && ( current_user.role?(:shipper))
      @unshipped_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(10)
      @shipped_orders = Order.shipped.chronological.paginate(:page => params[:page]).per_page(10)
    elsif logged_in? && ( current_user.role?(:customer))

      @all_items = Hash.new
      all_orders = current_user.customer.orders

      all_orders.each do |o|

        all_order_items = OrderItem.all.where(order_id: o.id)

        all_order_items.each do |oi|

            if @all_items.keys.include?(oi.item_id)
              @all_items[oi.item_id] += 1
            else
              @all_items[oi.item_id] = 1
            end

        end
      end
      @first = current_user.customer.proper_name
      @previous_orders = current_user.customer.orders.chronological.to_a

    else


    end
  end

  def about
  end

  def privacy
  end

  def contact
  end

  def search
    @query = params[:query]

    if logged_in? && ( current_user.role?(:admin))
      @items = Item.search(@query)
      @customers = Customer.search(@query)
      @total_hits = @items.size + @customers.size
    else
      @items = Item.search(@query)
      @total_hits = @items.size
    end
  end

end