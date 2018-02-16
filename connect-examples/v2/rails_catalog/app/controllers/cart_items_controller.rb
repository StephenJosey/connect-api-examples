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
    pp @items
    @cart.remove_product(params)
  end
end
