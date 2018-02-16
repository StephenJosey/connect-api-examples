class ItemController < ApplicationController
  def view
    catalog_api = SquareConnect::CatalogApi.new
    object_id = params[:object_id]
    begin
      @object = catalog_api.retrieve_catalog_object(object_id).object
      @parent_object = catalog_api.retrieve_catalog_object(@object.item_variation_data.item_id).object
    rescue SquareConnect::ApiError => e
      puts "Error while calling retrieve_catalog_object: #{e}"
    end
  end

  def update
    catalog_api = SquareConnect::CatalogApi.new
    body = {
      idempotency_key: SecureRandom.uuid,
      object: update_object(fetch_object(params[:object]),
                            params[:name], params[:price])
    }
    begin
      catalog_api.upsert_catalog_object(body)
      redirect_to :controller => 'catalog', :action => 'index'
    rescue SquareConnect::ApiError => e
      puts "Error while calling upset_catalog_object: #{e.code}"
    end
  end

  # this simply changes the catalog_object's properties
  # see docs (https://docs.connect.squareup.com/api/connect/v2#type-catalogobject) for all possible properties
  def update_object(object, name, price)
    object.item_variation_data.name = name
    object.item_variation_data.price_money.amount = (price.to_f * 100).to_i
    object
  end

  # retrieves the object based on id, as we can't pass the object back from the view
  def fetch_object(object_id)
    catalog_api = SquareConnect::CatalogApi.new
    catalog_api.retrieve_catalog_object(object_id).object
  end
end
