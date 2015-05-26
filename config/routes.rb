def api_version_helper(version, mime, &block)
  version_str = "v#{version}"
  api_version module: version_str,
              path: { value: version_str },
              parameter: { name: :apiVersion, value: version_str },
              &block
  scope as: :header do
    api_version module: version_str, header: { name: :Accept, value: "#{mime};version=#{version}" }, &block
  end
end

Rails.application.routes.draw do
  controller :profile, path: :user do
    get '(:username)', action: :show, as: :profile
    get '(:username)/feed' => 'feed#user', as: :feed_profile
    get '(:username)/files', action: :files, as: :profile_files
    get '(:username)/versions', action: :versions, as: :profile_versions
    get '(:username)/brief_feed' => 'feed#brief_user', as: :brief_feed_profile
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    scope path: 'users' do
      match 'finish_signup' => 'users/registrations#finish_signup', via: [:get, :patch, :post], as: :finish_signup
      get 'accounts' => 'users/registrations#accounts', as: :user_accounts
      get 'auth/:provider/destroy' => 'users/omniauth_callbacks#destroy', as: :omniauth_unlink
      match 'reset_authentication_token' => 'users/registrations#reset_authentication_token',
            via: [:get, :patch, :post], as: :reset_authentication_token

      resources :uploaders do
        member do
          match 'reset_token', via: [:get, :patch, :post]
        end
      end
    end
  end

  authenticate :user, ->(user) { user.admin } do
    mount DjMon::Engine => 'dj_mon'
  end

  post 'upload_version' => 'wonko_versions#upload'

  resources :wonko_files, id: %r{[^/]+} do
    member do
      get 'feed' => 'feed#file'
      scope controller: 'wonko_files_transfer' do
        get 'transfer'
        post 'transfer'
        get 'accept_transfer'
        get 'reject_transfer'
        get 'cancel_transfer'
      end
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

  namespace :api,
            format: true,
            constraints: { format: :json },
            defaults: { format: :json },
            wonko_file_id: %r{[^/]+},
            id: %r{[^/]+} do
    api_version_helper 1, 'application/wonkoweb-api' do
      scope controller: 'wonko_files' do
        root action: :index
        get 'index', action: :index, as: :index
        get ':id', action: :show, as: :file
        post action: :create, as: :create_file
        patch ':id', action: :update
      end
      scope path: ':wonko_file_id', controller: 'wonko_versions' do
        get ':id', action: :show, as: :version
        post action: :create, as: :create_version
        patch ':id', action: :update
      end
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
