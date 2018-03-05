Rails.application.routes.draw do
  resources :shipments
  post 'shipments/:id/deliver', to: 'shipments#deliver'
end
