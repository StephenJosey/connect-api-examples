class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_cart
  before_action :access_cart

  # set the cart for each user
  private

  def set_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end

  # save all current cart items in @items to be accessed in views
  def access_cart
    catalog_api = SquareConnect::CatalogApi.new
    @items = []
    CartItem.find_each do |item|
      if item.cart_id == session[:cart_id]
        begin
          product = catalog_api.retrieve_catalog_object(item.product_id)
          parent = catalog_api.retrieve_catalog_object(item.parent_id)
          @items.append(product: product, parent: parent,
                        quantity: item.quantity, id: item.id)
        rescue SquareConnect::ApiError => e
          puts "Exception when calling CatalogApi->retrieve_object: #{e}"
        end
      end
    end
  end
end
