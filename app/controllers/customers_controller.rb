class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :check_login, except: [:new, :create]

  authorize_resource

  def index
    @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @previous_orders = @customer.orders.chronological
  end

  def new
    # authorize! :new, @customer
    @customer = Customer.new
    @customer.build_user
  end

  def edit
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
  end

  def create
    byebug
    @customer = Customer.new(customer_params)
    # @user = User.new(user_params)
    # @user.role = "customer"
    @customer.user.role = "customer"
    @customer.user.active = true
    # if !@user.save
    #   @customer.valid?
    #   render action: 'new'
    # else
    #   @customer.user_id = @user.id

      if @customer.save

        redirect_to home_path, notice: "#{@customer.proper_name} was added to the system"
        # flash[:notice] = "Successfully created #{@customer.proper_name}."

        #   if ( current_user.role?(:customer))
        #             redirect_to home_path() 
        #   else
        #     redirect_to customer_path()
        #   end
      else
        render action: 'new'
      end      

  end

  def update
    byebug
    # authorize! :update, @customer
    if @customer.update_attributes(customer_params)
      redirect_to @customer, notice: "#{@customer.proper_name} was revised in the system."
    else
      render action: 'edit'
    end
  end


  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active, :id, user_attributes: [:id, :username, :password, :password_confirmation])
  end

end