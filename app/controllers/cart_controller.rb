class CartController < ApplicationController

    include AppHelpers::Cart

	def show
		@cart_item_list = get_list_of_items_in_cart
		@cost = calculate_cart_items_cost
	end

	def add_to_cart
		add_item_to_cart(params[:id])
		redirect_to show_cart_path()
	end

	def remove_from_cart
		remove_item_from_cart(params[:id])
		redirect_to show_cart_path()
	end

	def clear_the_cart
		clear_cart
		redirect_to show_cart_path
	end

	def checkout
		# @session_user = User.where(id: session[:user_id])
		@customer_customer = current_user.customer
		@session_address = @customer_customer.addresses.billing.first
		@proper_date = Date.current
		@total_cost = calculate_cart_items_cost
		@new_order = Order.create(customer: @customer_customer, address: @session_address, date: @proper_date, grand_total: @total_cost)

    	@new_order.credit_card_number = "4123456789012"
    	@new_order.expiration_year = "2019"
    	@new_order.expiration_month = "12"

		@new_order.pay
		@new_order.reload		
		save_each_item_in_cart(@new_order)
		@new_order.save!
		redirect_to show_cart_path
	end



end