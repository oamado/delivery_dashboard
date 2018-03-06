Rails.application.routes.draw do
  root to: 'shipments#index'
  resources :shipments
  post 'shipments/:id/deliver', to: 'shipments#deliver'
end
