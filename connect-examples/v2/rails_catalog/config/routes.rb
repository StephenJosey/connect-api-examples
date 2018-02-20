Rails.application.routes.draw do
  post 'item', to: 'item#view'
  post 'item/update'
  get 'item/create'
  post 'item/create'
  post 'item/delete'

  get 'catalog', to: 'catalog#index'

  post 'cart_items/create'
  get 'cart_items/', to: 'cart_items#view'
  post 'cart_items/remove'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
