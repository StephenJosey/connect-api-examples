class CartItemsController < ApplicationController
  before_action :set_cart
  before_action :access_cart
  def view; end

  def create
    result = @cart.add_product(params)

    if @cart.save && !result.nil?
      redirect_to '/catalog'
      flash[:success] = 'Item added to cart'
    else
      flash[:error] = 'There was a problem adding it to cart'
    end
  end

  def remove
    @cart.remove_product(params)
    flash[:success] = 'Item successfully removed from cart!'
    redirect_back(fallback_location:
                    { controller: 'cart_items', action: 'index' })
  end
end
