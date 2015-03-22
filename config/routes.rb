Rails.application.routes.draw do
  get 'profile/login'

  get 'profile/logout'

  get 'profile/profile'

  devise_for :users

  post 'upload_version' => 'wonko_versions#upload'

  resources :wonko_files, id: /[^\/]+/ do
    resources :wonko_versions, id: /[^\/]+/ do
      member do
        get 'copy'
      end
    end
  end

  root 'home#index'
  get 'about' => 'home#about'
  get 'irc' => 'home#irc'

  get 'files/' => 'wonko_files#index', defaults: { format: 'json' }, as: :files_root
  get 'files/index.json' => 'wonko_files#index', defaults: { format: 'json' }, as: :files_index
  get 'files/:wonko_file_id/:id.json' => 'wonko_versions#show', wonko_file_id: /[^\/]+/, id: /[^\/]+/, defaults: { format: 'json' }, as: :files_version
  get 'files/:id.json' => 'wonko_files#show', id: /[^\/]+/, defaults: { format: 'json' }, as: :files_file

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
