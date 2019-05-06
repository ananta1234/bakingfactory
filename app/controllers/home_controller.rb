class HomeController < ApplicationController

  include AppHelpers::Baking

  def home
    if logged_in? && ( current_user.role?(:admin))

      #Find all the total sales amounts for every month of this year
      @this_year = Date.current.year.to_s
      @beginning_of_year = DateTime.parse(Time.parse("#{Date.current}").strftime("%Y-01-01")).to_date 
      @last_year = @beginning_of_year - 1.year
      @previous_two_years =  @beginning_of_year - 2.year

      @orders_from_this_year = Order.all.select{|o| o.date >= @beginning_of_year}
      @orders_from_last_year = Order.all.select{|o| o.date >= @last_year}.select{|o| o.date <= @beginning_of_year}
      @orders_from_2_years_ago = Order.all.select{|o| o.date >= @previous_two_years}.select{|o| o.date <= @last_year}

      @data = []
      @data1 = []
      @data2 = []


      @months = []

      @end = Date.current.month

      (1..@end).each do |month| 

        @sales_from_month = @orders_from_this_year.select {|o| o.date.month == month}.sum(&:grand_total)
        @sales_from_month1 = @orders_from_last_year.select {|o| o.date.month == month}.sum(&:grand_total)
        @sales_from_month2 = @orders_from_2_years_ago.select {|o| o.date.month == month}.sum(&:grand_total)



        @data << @sales_from_month
        @data1 << @sales_from_month1
        @data2 << @sales_from_month2

        @months << Date::MONTHNAMES[month]
        
      end

    #By Week
    @week_data = [0,0,0,0,0,0,0]

    Order.all.each do |o|

      @order_day = o.date.wday

      @week_data[@order_day] = @week_data[@order_day] + o.grand_total
      
    end


    #Items dashboard stuff
    @all_items = Item.all.map(&:name)
    @all_item_ids = Item.all.map(&:id)
    @all_item_total_quan = []


    @all_item_ids.each do |item_id|

      @number_of_item = 0
      @order_items_for_item = OrderItem.all.where(item_id: item_id)

      @order_items_for_item.each do |oi|

        @number_of_item = @number_of_item + oi.quantity
        
      end

      @all_item_total_quan << @number_of_item

    #Customers dashboard stuff
    @all_customers = Customer.all.map {|c| c.proper_name}
    @all_cust_ids = Customer.all.map(&:id)
    @all_customer_total_quan = []


    @all_cust_ids.each do |cust_id|

      @all_cust_orders = Order.all.where(customer_id: cust_id)

      @total_orders = 0

            @all_cust_orders.each do |o|

            @number_of_item = 0
            @order_items_for_item = OrderItem.all.where(order_id: o.id)

                @order_items_for_item.each do |oi|

                  @number_of_item = @number_of_item + oi.quantity
                  
                end

            @total_orders = @total_orders + @number_of_item
        
          end

      @all_customer_total_quan <<  @total_orders

      end
    end


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