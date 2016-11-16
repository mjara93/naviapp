Rails.application.routes.draw do
namespace :api, defaults: {format: 'json'} do
  resources :accounts, only: [:index, :create, :destroy, :update, :show]
  resources :crews
  resources :trips
  resources :locations
end
  resources :sales
  resources :clients
  resources :locations
  resources :trips
  resources :purchases
  resources :providers
  resources :ships
  resources :positions
  resources :cities
  resources :products
  resources :cities
  resources :clients
  resources :sales
  resources :products
  resources :providers
  resources :purchases
  resources :ships
  resources :accounts
  resources :positions
  resources :crews
  devise_for :users
  resources :main
  resources :calculos
  resources :maps
  resources :settings

  get "reporte" => "calculos#index"
  get "reporte/mensual" => "calculos#ejemplo"
  get "reporte/pdf" => "calculos#pdf"
  get "calculos/show"
  get "reporte/anual" => "calculos#reporteY"
  get "reporte/pdf_anual" => "calculos#reporteY_pdf"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'main#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
