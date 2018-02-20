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
      object: update_object(fetch_object(params[:object_id]),
                            params[:name], params[:price])
    }
    begin
      catalog_api.upsert_catalog_object(body)
      redirect_to :controller => 'catalog', :action => 'index'
    rescue SquareConnect::ApiError => e
      puts "Error while calling upset_catalog_object: #{e.code}"
    end
  end

  def delete
    catalog_api = SquareConnect::CatalogApi.new
    begin
      catalog_api.delete_catalog_object(params[:object_id])
      flash[:success] = 'Item successfully deleted!'
      redirect_to :controller => 'catalog', :action => 'index'
    rescue SquareConnect::ApiError => e
      puts "Error while trying to delete object #{e.response_body}"
    end
  end

  def create
    @categories = list_categories.append(name: 'New...')
    @product_groups = list_product_groups.append(name: 'New...');
    if params[:name].present? || params[:new_product].present?
      catalog_api = SquareConnect::CatalogApi.new
      body = SquareConnect::BatchUpsertCatalogObjectsRequest.new
      body.idempotency_key = SecureRandom.uuid
      body.batches = [{
        objects: []
      }]
      parent_id = params[:name]
      category_id = params[:category]
      if params[:new_category] != ''
        category_id = "##{params[:new_category]}"
        body.batches[0][:objects].append(form_category_object(category_id))
      end
      if params[:new_product] != ''
        parent_id = "##{params[:new_product]}"
        body.batches[0][:objects].append(form_parent_object(parent_id, category_id))
      end
      item = form_variation_object(parent_id, params[:variation_name], params[:price], category_id)
      body.batches[0][:objects].append(item)

      begin
        catalog_api.batch_upsert_catalog_objects(body)
        flash[:success] = 'Item successfully created!'
        redirect_to :controller => 'catalog', :action => 'index'
      rescue SquareConnect::ApiError => e
        puts "Error while calling upsert_catalog_object: #{e.response_body}"
      end
    end
  end

  # this simply changes the catalog_object's properties
  # see docs (https://docs.connect.squareup.com/api/connect/v2#type-catalogobject)
  # for all possible properties
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

  def form_parent_object(name, category)
    object = {
      id: name,
      type: SquareConnect::CatalogObjectType::ITEM,
      item_data: {
        name: name.delete('#'),
        category_id: category
      }
    }
  end

  def form_category_object(name)
    object = {
      id: name,
      type: SquareConnect::CatalogObjectType::CATEGORY,
      category_data: {
        name: name.delete('#')
      }
    }
  end

  # creates the variation, based on the template that is found in the docs
  def form_variation_object(name, variation, price, category)
    object = {
      id: "##{variation}",
      type: SquareConnect::CatalogObjectType::ITEM_VARIATION,
      item_variation_data: {
        item_id: name,
        name: variation,
        category_id: category,
        pricing_type: SquareConnect::CatalogPricingType::FIXED_PRICING,
        price_money: {
          amount: (price.to_f * 100).to_i,
          currency: SquareConnect::Currency::USD
        }
      }
    }
  end

  def list_product_groups
    catalog_api = SquareConnect::CatalogApi.new
    opts = {
      types: SquareConnect::CatalogObjectType::ITEM
    }
    begin
      response = catalog_api.list_catalog(opts)
      product_groups = []
      response.objects.each do |item|
        product_groups.append(name: item.item_data.name, id: item.id)
      end
      return product_groups
    rescue SquareConnect::ApiError => e
      puts "Error while calling list_catalog: #{e.response_body}"
    end
  end

  def list_categories
    catalog_api = SquareConnect::CatalogApi.new
    opts = {
      types: SquareConnect::CatalogObjectType::CATEGORY
    }
    begin
      response = catalog_api.list_catalog(opts)
      category_names = []
      response.objects.each do |category|
        category_names.append(name: category.category_data.name, id: category.id)
      end
      return category_names
    rescue SquareConnect::ApiError => e
      puts "Error while calling list_catalog: #{e.response_body}"
    end
  end
end
