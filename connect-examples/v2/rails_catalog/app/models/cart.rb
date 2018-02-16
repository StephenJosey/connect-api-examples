class Cart < ApplicationRecord
  has_many :cart_items
  def add_product(params)
    return nil if params[:product_id].nil? || params[:quantity].nil?

    current_item = cart_items.find_by(product_id: params[:product_id].to_s)

    if current_item
      current_item.quantity += params[:quantity].to_i
      current_item.save
    else
      cart_items.create(product_id: params[:product_id].to_s,
                        quantity: params[:quantity],
                        cart_id: id)
    end
  end

  def remove_product(params)
    pp cart_items.find_by(id: params[:id]).destroy
  end
end
