NolotiroOrg::Application.routes.draw do

  root 'ads#index'

  get '/:locale' => 'ads#index'

  # i18n
  scope "(:locale)", locale: /es|en|ca|gl|eu|nl|de|fr|pt|it/ do

    # ads
    get '/', to: 'ads#index'

    resources :ads, path: 'ad', path_names: { new: 'create' }
    
    # ads: optional slug
    get '/ad/:id/:slug', to: 'ads#show', :as => 'adslug'

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
    get '/auth/login', to: redirect('/es/user/login')

    devise_for :users, path: 'user', path_names: {
      sign_up: 'register',
      sign_in: 'login',
      sign_out: 'logout',
      password: 'reset'
    }

    # ads lists for user
    get '/ad/listuser/id/:id', to: 'users#listads', as: 'listads_user'

    # public profile for user
    get '/profile/:username', to: 'users#profile', as: 'profile'

    # comments
    post '/comment/create/ad_id/:id', to: 'comments#create', as: 'create_comment'

    # search 
    get '/search', to: 'search#search', as: 'search'

    # TODO: messaging
    # /es/message/create/id_user_to/42825/subject/mueble-de-salon

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
