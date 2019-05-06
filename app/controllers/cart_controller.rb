class CartController < ApplicationController

    include AppHelpers::Cart

	def show
		@cart_item_list = get_list_of_items_in_cart
		@cost = calculate_cart_items_cost

		@order = Order.new
	end

	def add_to_cart
		add_item_to_cart(params[:id])
		redirect_to items_url, notice: "#{Item.find(params[:id]).name} was added to the cart."
	end

	def remove_from_cart
		remove_item_from_cart(params[:id])
		redirect_to show_cart_path(), notice: "#{Item.find(params[:id]).name} has been removed from the cart."
	end

	def clear_the_cart
		clear_cart
		redirect_to show_cart_path, notice: "Your cart has been cleared."
	end

	def checkout
		card_number = params["order"][:credit_card_number].to_s
		year = params["order"][:expiration_year].to_i
		month = params["order"][:expiration_month].to_i

		@current_customer = current_user.customer
		@session_address = @current_customer.addresses.billing.first
		@proper_date = Date.current
		@total_cost = calculate_cart_items_cost
		@new_order = Order.create(customer: @current_customer, address: @session_address, date: @proper_date, grand_total: @total_cost)

    	@new_order.credit_card_number = card_number
    	@new_order.expiration_year = year
    	@new_order.expiration_month = month

	    if @new_order.save
			@new_order.pay
			@new_order.reload		
			save_each_item_in_cart(@new_order)
			clear_cart
			redirect_to orders_path, notice: "Congratulations! We got your order and it is on it's way!"
	    else
	    	redirect_to show_cart_path, notice: "It seems there might be missing or invalid information. Please check your information and try again."
	    end

	end

	def add_payment

		@curr_order = Order.find(params[:id]) 

    	# @curr_order.credit_card_number = "4123456789012"
    	# @curr_order.expiration_year = 2019
    	# @curr_order.expiration_month = 12



		# @curr_order.pay
		# @curr_order.reload		
		# save_each_item_in_cart(@curr_order)
		# @curr_order.save!
		# clear_cart
		# redirect_to orders_path
	end

  def order_params
    params.require(:order).permit(:address_id, :customer_id, :grand_total)
  end

end