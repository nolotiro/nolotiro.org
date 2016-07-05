require 'sidekiq/web'

NolotiroOrg::Application.routes.draw do

  ActiveAdmin.routes(self)

  scope '/api' do
    scope '/v1' do
      get '/ad/:id', format: 'json', to: 'api/v1#ad_show', as: 'apiv1_ad_show'
      get '/woeid/:id/:type', format: 'json', to: 'api/v1#woeid_show', as: 'apiv1_woeid_show'
      get '/woeid/list', format: 'json', to: 'api/v1#woeid_list', as: 'apiv1_woeid_list'
    end
  end

 devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'callbacks'}

  # i18n
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

    root 'ads#index'

    # FIXME: type on ads#create instead of params
    # FIXME: nolotirov2 legacy - redirect from /es/ad/create
    resources :ads, path: 'ad', path_names: { new: 'create' }
    
    constraints(AdConstraint.new) do
      scope '/ad' do
        get '/:id/:slug', to: 'ads#show', :as => 'adslug'
        get '/edit/id/:id', to: 'ads#edit', :as => 'ads_edit'
        post '/bump/id/:id', to: 'ads#bump', :as => 'ads_bump'
        get '/listall/ad_type/:type(/status/:status)(/page/:page)',
            to: 'woeid#show',
            as: 'ads_listall'
        get '/listuser/id/:id(/type/:type)(/status/:status)(/page/:page)',
            to: 'users#listads',
            as: 'listads_user'
      end

      # locations lists
      get '/woeid/:id/:type(/status/:status)(/page/:page)',
          to: 'woeid#show',
          as: 'ads_woeid',
          constraints: { id: /\d+/ }
    end

    # location change
    scope '/location' do
      get  '/change', to: 'location#ask', as: 'location_ask'
      get  '/change2', to: 'location#change', as: 'location_change'
      post '/change', to: 'location#list'
      post '/change2', to: 'location#change'
    end

    devise_for :users,
      skip: :omniauth_callbacks,
      controllers: { registrations: 'registrations' },
      path: 'user',
      path_names: {
        sign_up: 'register',
        sign_in: 'login',
        sign_out: 'logout',
        password: 'reset'
    }

    post '/addfriend/id/:id', to: 'friendships#create', as: 'add_friend'
    post '/deletefriend/:id', to: 'friendships#destroy', as: 'destroy_friend'

    scope '/admin' do 
      authenticate :user, lambda { |u| u.admin? } do
        mount Sidekiq::Web, at: '/jobs'
      end
      get '/become/:id', to: 'admin#become', as: 'become_user' 
      get '/lock/:id', to: 'admin#lock', as: 'lock_user' 
      get '/unlock/:id', to: 'admin#unlock', as: 'unlock_user' 
    end

    get '/user/edit/id/:id', to: redirect('/es/user/edit'), as: 'user_edit'
    get '/profile/:username', to: 'users#profile', as: 'profile'

    # comments
    post '/comment/create/ad_id/:id', to: 'comments#create', as: 'create_comment'

    # search 
    get '/search', to: 'search#search', as: 'search'

    # messaging
    resources :mailboxer_messages, controller: :messages, path: '/messages/' do
      member do
        delete 'trash'
        post 'untrash'
      end
      collection do
        delete 'trash'
      end
    end

    post 'messages/search', to: 'messages#search', as: 'search_mailboxer_messages'

    # messaging legacy
    scope '/message' do
      get  '/received', to: redirect('/es/message/list'), as: 'messages_received'
      get  '/list', to: 'messages#index', as: 'messages_list'
      get  '/show/:id/subject/:subject', to: 'messages#show', as: 'message_show'
      get  '/create/id_user_to/:user_id', to: 'messages#new', as: 'message_new'
      get  '/create/id_user_to/:user_id/subject/:subject', to: 'messages#new', as: 'message_new_with_subject'
      post '/create/id_user_to/:user_id', to: 'messages#create', as: 'message_create'
      post '/create/id_user_to/:user_id/subject/:subject', to: 'messages#create', as: 'message_create_with_subject'
      post '/reply/:id/to/:user_id', to: 'messages#reply', as: 'message_reply'
    end

    # rss
    # nolotirov2 - legacy 
    # FIX: las URLs legacy vienen asi
    # /en                     /rss/feed/woeid/766273                     /ad_type/give
    # Lo solucionamos en el nginx.conf y una configuracion para hacer el search and replace
    # http://stackoverflow.com/questions/22421522/nginx-rewrite-rule-for-replacing-space-whitespace-with-hyphen-and-convert-url-to
    scope '/rss' do
      get '/feed/woeid/:woeid/ad_type/:type', format: 'rss', to: 'rss#feed', as: 'rss_type'
      get '/feed/woeid/:woeid/ad_type/give/status/:status', format: 'rss', to: 'rss#feed', as: 'rss_status'
    end

    scope '/page' do
      get '/faqs', to: 'page#faqs', as: 'faqs'
      get '/tos', to: redirect('/page/privacy')
      get '/about', to: 'page#about', as: 'about'
      get '/privacy', to: 'page#privacy', as: 'privacy'
      get '/legal', to: 'page#legal', as: 'legal'
      get '/translate', to: 'page#translate', as: 'translate'
    end

    # contact
    get '/contact', to: 'contact#new', as: 'contacts'
    post '/contact', to: 'contact#create'
  end

end
