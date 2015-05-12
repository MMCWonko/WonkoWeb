def api_version_helper(version, _mime, &block)
  version_str = "v#{version}"
  api_version module: version_str, path: { value: version_str }, &block
  # api_version module: "#{version_str}_header", header: { name: :Accept, value: "#{mime};version=#{version}" }, &block
  api_version module: "#{version_str}_query", parameter: { name: :apiVersion, value: version_str }, &block
end

Rails.application.routes.draw do
  controller :profile, path: :user do
    get '(:username)', action: :show, as: :profile
    get '(:username)/feed' => 'feed#user', as: :feed_profile
    get '(:username)/files', action: :files, as: :profile_files
    get '(:username)/versions', action: :versions, as: :profile_versions
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    match '/users/finish_signup' => 'users/registrations#finish_signup', via: [:get, :patch, :post], as: :finish_signup
  end

  authenticate :user, ->(user) { user.admin } do
    mount DjMon::Engine => 'dj_mon'
  end

  post 'upload_version' => 'wonko_versions#upload'

  resources :wonko_files, id: %r{[^/]+} do
    member do
      get 'feed' => 'feed#file'
    end

    resources :wonko_versions, id: %r{[^/]+} do
      member do
        get 'copy'
        get 'feed' => 'feed#version'
      end
    end
  end

  root 'home#index'
  get 'about' => 'home#about'
  get 'irc' => 'home#irc'

  namespace :api do
    api_version_helper 1, 'application/wonkoweb-api' do
      root 'wonko_files#index', defaults: { format: 'json' }, as: :files_root
      get 'index.json' => 'wonko_files#index', defaults: { format: 'json' }, as: :files_index
      get ':wonko_file_id/:id.json' => 'wonko_versions#show', wonko_file_id: %r{[^/]+}, id: %r{[^/]+},
          defaults: { format: 'json' }, as: :files_version
      get ':id.json' => 'wonko_files#show', id: %r{[^/]+}, defaults: { format: 'json' }, as: :files_file
    end
  end

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
