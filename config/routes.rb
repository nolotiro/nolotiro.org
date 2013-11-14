NolotiroOrg::Application.routes.draw do

  root 'ads#index'

  get '/:locale' => 'ads#index'

  # i18n
  scope "(:locale)", locale: /es|en|ca|gl|eu|nl|de|fr|pt|it/ do

    # ads
    get '/', to: 'ads#index'
    # TODO: optional slug
    # /es/ad/146609/regalo-moises 
    resources :ads, path: 'ad', path_names: {
      new: 'create'
    }

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

    # comments
    post '/comment/create/ad_id/:id', to: 'comments#create', as: 'create_comment'

    # search 
    get '/search', to: 'search#search', as: 'search'

    # TODO: messaging
    # /es/message/create/id_user_to/42825/subject/mueble-de-salon

    # TODO: rss
    # /es/rss/feed/woeid/766273/ad_type/give

    get '/page/faqs', to: 'page#faqs'
    get '/page/tos', to: 'page#tos'
    get '/page/about', to: 'page#about'
    get '/page/privacy', to: 'page#privacy'
    get '/page/translate', to: 'page#translate'

    # TODO: contact
    # /es/contact
    
    # i18n legacy
    # do nothing, the locale is in the link
    get '/index/setlang', to: redirect('/')

  end

end
