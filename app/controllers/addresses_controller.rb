class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  
  def index

    if logged_in? && ( current_user.role?(:admin) || current_user.role?(:shipper))
      @active_addresses = Address.active.by_customer.by_recipient.paginate(:page => params[:page]).per_page(10)
      @inactive_addresses = Address.inactive.by_customer.by_recipient.paginate(:page => params[:page]).per_page(10)
    else
      @current_customer = current_user.customer
      @customer_addresses = @current_customer.addresses
    end
  end

  def show
  end

  def new
    @address = Address.new
  end

  def edit
  end

  def create
    @address = Address.new(address_params)
    if logged_in? && current_user.role?(:customer)
      @address.customer_id = current_user.customer.id
    end
    if @address.save
      redirect_to customer_path(@address.customer), notice: "The address was added to #{@address.customer.proper_name}."
    else
      render action: 'new'
    end
  end

  def update
    if @address.update(address_params)
      redirect_to addresses_path, notice: "The address was revised in the system."
    else
      render action: 'edit'
    end
  end


  private
  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:customer_id, :recipient, :street_1, :street_2, :city, :state, :zip, :active, :is_billing, :customer_id)
  end

end