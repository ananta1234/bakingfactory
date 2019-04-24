class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # i.e., a guest user
    
    if user.role? :admin

      can :manage, :all
      
    elsif user.role? :customer

        can :show, Item

    	can :show, User do |u|  
    		u.id == user.id
    	end

    	can :show, Customer do |this_customer|  
    		this_customer.id == user.customer.id
    	end

    	can :show, Address do |this_address|  
    		my_addresses = user.customer.addresses.map(&:id)
    		my_addresses.include? this_address.id
    	end

    	can :show, Order do |this_order|  
    		my_orders = user.customer.orders.map(&:id)
    		my_orders.include? this_order.id
    	end

    	can :index, Item
    	can :index, Order
    	can :index, Address

    	can :update, User do |u|  
    		u.id == user.id
    	end

    	can :update, Customer do |this_customer|  
    		this_customer.id == user.customer.id
    	end

    	can :update, Address do |this_address|  
    		my_addresses = user.customer.addresses.map(&:id)
    		my_addresses.include? this_address.id
    	end

    	can :update, Order do |this_order|  
    		my_orders = user.customer.orders.map(&:id)
    		my_orders.include? this_order.id
    	end

    	can :add_to_cart, Order
    	can :checkout, Order

    	can :create, Address
    	can :create, Order

    elsif user.role? :baker

    	can :show, Item
    	can :index, Item
    	can :index, Order

    elsif user.role? :shipper

    	can :show, Item
    	can :index, Item
    	can :index, Order
    	can :show, Address
        can :index, Address
    	can :show, Order

    else
    	can :show, Item
    	can :index, Item
    	can :create, Customer

    end
  end
end
