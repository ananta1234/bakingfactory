class HomeController < ApplicationController

  include AppHelpers::Baking

  def home
    @baking_list = create_baking_list_for("muffins")
  end

  def about
  end

  def privacy
  end

  def contact
  end

  def search
    @query = params[:query]
    @items = Item.search(@query)
    @total_hits = @items.size
  end

end