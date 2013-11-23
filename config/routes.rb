NolotiroOrg::Application.routes.draw do

  root 'ads#index'

  get '/:locale' => 'ads#index'

  scope '/api' do
    scope '/v1' do
      get '/ad/:id', format: 'json', to: 'api/v1#ad_show', as: 'apiv1_ad_show'
      get '/woeid/:id/:type', format: 'json', to: 'api/v1#woeid_show', as: 'apiv1_woeid_show'
      get '/woeid/list', format: 'json', to: 'api/v1#woeid_list', as: 'apiv1_woeid_list'
    end
  end

  # i18n
  scope "(:locale)", locale: /es|en|ca|gl|eu|nl|de|fr|pt|it/ do

    # ads
    get '/', to: 'ads#index'

    resources :ads, path: 'ad', path_names: { new: 'create' }
    
    # ads: optional slug
    get '/ad/:id/:slug', to: 'ads#show', :as => 'adslug'
    get '/ad/edit/id/:id', to: 'ads#edit', :as => 'ads_edit'

    # listall
    get '/ad/listall/ad_type/give', to: 'woeid#listall_give', as: "listall_give" 
    get '/ad/listall/ad_type/give/status/available', to: 'woeid#listall_give_available', as: 'listall_give_available'
    get '/ad/listall/ad_type/give/status/delivered', to: 'woeid#listall_give_delivered', as: 'listall_give_delivered'
    get '/ad/listall/ad_type/give/status/booked', to: 'woeid#listall_give_booked', as: 'listall_give_booked'
    get '/ad/listall/ad_type/want', to: 'woeid#listall_want', as: "listall_want" 

    # locations lists
    get '/woeid/:id/want', to: 'woeid#want', as: 'woeid_want'
    get '/woeid/:id/give', to: 'woeid#available', as: 'woeid'
    get '/woeid/:id/give/status/booked', to: 'woeid#booked', as: 'woeid_booked'
    get '/woeid/:id/give/status/delivered', to: 'woeid#delivered', as: 'woeid_delivered'

    # location change
    get '/location/change', to: 'location#ask', as: 'location_ask'
    post '/location/change/', to: 'location#list'
    get '/location/change2/', to: 'location#list'
    post '/location/change2/', to: 'location#change'

    # auth
    get '/auth/login', to: redirect('/user/login')

    devise_for :users,
      :controllers => { :registrations => 'registrations' },
      path: 'user',
      path_names: {
        sign_up: 'register',
        sign_in: 'login',
        sign_out: 'logout',
        password: 'reset'
    }

    get '/ad/listuser/id/:id', to: 'users#listads', as: 'listads_user'
    get '/user/edit/id/:id', to: redirect('/es/user/edit'), as: 'user_edit'
    get '/profile/:username', to: 'users#profile', as: 'profile'

    # comments
    post '/comment/create/ad_id/:id', to: 'comments#create', as: 'create_comment'

    # search 
    get '/search', to: 'search#search', as: 'search'

    # messaging
    get '/message/list', to: 'messages#list', as: 'messages_list'
    get '/message/show/:id/subject/:subject', to: 'messages#show', as: 'message_show'

    get '/message/create/id_user_to/:user_id', to: 'messages#new', as: 'message_new'
    get '/message/create/id_user_to/:user_id/subject/:subject', to: "messages#new", as: 'message_new_with_subject'
    post '/message/create/id_user_to/:user_id', to: 'messages#create', as: 'message_create'
    post '/message/create/id_user_to/:user_id/subject/:subject', to: "messages#create", as: 'message_create_with_subject'

    post '/message/reply/:id/to/:message_id', to: 'messages#reply', as: 'message_reply'

    # rss
    # FIXME: las URLs legacy vienen asi
    # /en                     /rss/feed/woeid/766273                     /ad_type/give
    get '/rss/feed/woeid/:woeid/ad_type/:type', format: 'rss', to: 'rss#feed', as: 'rss_type'
    get '/rss/feed/woeid/:woeid/ad_type/give/status/:status', format: 'rss', to: 'rss#feed', as: 'rss_status'

    get '/page/faqs', to: 'page#faqs', as: 'faqs'
    get '/page/tos', to: 'page#tos', as: 'tos'
    get '/page/about', to: 'page#about', as: 'about'
    get '/page/privacy', to: 'page#privacy', as: 'privacy'
    get '/page/translate', to: 'page#translate', as: 'translate'

    # contact
    get '/contact', to: 'contact#new', as: 'contacts'
    post '/contact', to: 'contact#create'
    
    # i18n legacy
    # do nothing, the locale is in the link
    get '/index/setlang', to: redirect('/')

  end

end
