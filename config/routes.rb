NolotiroOrg::Application.routes.draw do

  get '/', to: redirect('/es')

  scope '/api' do
    scope '/v1' do
      get '/ad/:id', format: 'json', to: 'api/v1#ad_show', as: 'apiv1_ad_show'
      get '/woeid/:id/:type', format: 'json', to: 'api/v1#woeid_show', as: 'apiv1_woeid_show'
      get '/woeid/list', format: 'json', to: 'api/v1#woeid_list', as: 'apiv1_woeid_list'
    end
  end

  # i18n
  scope "(:locale)", locale: /es|en|ca|gl|eu|nl|de|fr|pt|it/ do

    root 'ads#index'

    resources :ads, path: 'ad', path_names: { new: 'create' }
    
    scope '/ad' do
      get '/:id/:slug', to: 'ads#show', :as => 'adslug'
      get '/edit/id/:id', to: 'ads#edit', :as => 'ads_edit'
      get '/listall/ad_type/:type', to: 'woeid#show', as: "ads_listall" 
      get '/listall/ad_type/:type/status/:status', to: 'woeid#show', as: 'ads_listall_status'
      get '/listuser/id/:id', to: 'users#listads', as: 'listads_user'
    end

    # locations lists
    get '/woeid/:id/:type', to: 'woeid#show', as: 'ads_woeid'
    get '/woeid/:id/:type/status/:status', to: 'woeid#show', as: 'ads_woeid_status'

    # location change
    scope '/location' do
      get  '/change', to: 'location#ask', as: 'location_ask'
      get  '/change2', to: 'location#change'
      post '/change', to: 'location#list'
      post '/change2', to: 'location#change'
    end

    # auth
    get '/auth/login', to: redirect('/es/user/login')
    get '/user/forgot', to: redirect('/es/user/reset/new')

    devise_for :users,
      :controllers => { :registrations => 'registrations' },
      path: 'user',
      path_names: {
        sign_up: 'register',
        sign_in: 'login',
        sign_out: 'logout',
        password: 'reset'
    }

    post '/addfriend/id/:id', to: 'friendships#create', as: 'create_friend'
    post '/deletefriend/:id', to: 'friendships#destroy', as: 'destroy_friend'

    scope '/admin' do 
      # config/initializers/admin.rb
      constraints CanAccessResque do
        mount Resque::Server, :at => "/resque"
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
    scope '/message' do
      get  '/received', to: redirect('/es/message/list'), as: 'messages_received'
      get  '/list', to: 'messages#list', as: 'messages_list'
      get  '/show/:id/subject/:subject', to: 'messages#show', as: 'message_show'
      get  '/create/id_user_to/:user_id', to: 'messages#new', as: 'message_new'
      get  '/create/id_user_to/:user_id/subject/:subject', to: "messages#new", as: 'message_new_with_subject'
      post '/create/id_user_to/:user_id', to: 'messages#create', as: 'message_create'
      post '/create/id_user_to/:user_id/subject/:subject', to: "messages#create", as: 'message_create_with_subject'
      post '/reply/:id/to/:user_id', to: 'messages#reply', as: 'message_reply'
    end

    # rss
    # FIXME: las URLs legacy vienen asi
    # /en                     /rss/feed/woeid/766273                     /ad_type/give
    scope '/rss' do
      get '/feed/woeid/:woeid/ad_type/:type', format: 'rss', to: 'rss#feed', as: 'rss_type'
      get '/feed/woeid/:woeid/ad_type/give/status/:status', format: 'rss', to: 'rss#feed', as: 'rss_status'
    end

    scope '/pages' do
      get '/faqs', to: 'page#faqs', as: 'faqs'
      get '/tos', to: 'page#tos', as: 'tos'
      get '/about', to: 'page#about', as: 'about'
      get '/privacy', to: 'page#privacy', as: 'privacy'
      get '/translate', to: 'page#translate', as: 'translate'
    end

    # contact
    get '/contact', to: 'contact#new', as: 'contacts'
    post '/contact', to: 'contact#create'
    
    # i18n legacy
    # do nothing, the locale is in the link
    get '/index/setlang', to: redirect('/')

  end

end
