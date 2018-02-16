class CatalogController < ApplicationController
  def index
    catalog_api = SquareConnect::CatalogApi.new
    begin
      @catalog_objects = catalog_api.list_catalog.objects
    rescue SquareConnect::ApiError => e
      puts "Error while calling list_catalog from API: #{e}"
    end
  end
end
