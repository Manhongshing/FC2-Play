Fc2play::Application.routes.draw do


  root 'home#index'

  ### for under construction ###
  #root 'home#coming_soon'

  get 'test' => 'home#test'
  get 'log' => 'home#log', as: :log
  get 'admin' => 'admin#index', as: :admin
  get 'play' => 'home#play', as: :play
  get 'search' => 'home#search', as: :search
  get 'flash_tag' => 'home#flash_tag', as: :flash_tag
  get 'get_path' => 'home#get_path', as: :get_path
  post 'bug_report' => 'bug_reports#create', as: :bug_report
  post 'change_window_size' => 'windows#change_size', as: :change_window_size
  delete 'report' => 'home#report', as: :report

  resources :sessions

  resources :favs

  resources :users

  resources :surveys

  get '*path', controller: 'application', action: 'render_404'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
