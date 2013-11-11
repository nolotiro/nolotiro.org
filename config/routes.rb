NolotiroOrg::Application.routes.draw do

  root 'ads#index'

  # TODO: i18n
  scope '/es' do

    # ads
    get '/', to: 'ads#index'
    # TODO: optional slug
    # /es/ad/146609/regalo-moises 
    resources :ads, path: 'ad', path_names: {
      new: 'create'
    }

    # TODO: listall
    # /es/ad/listall/ad_type/give
    # /es/ad/listall/ad_type/give/status/booked

    # locations lists
    get '/woeid/:id/want', to: 'woeid#want'
    get '/woeid/:id/give', to: 'woeid#available', as: 'woeid'
    get '/woeid/:id/give/status/booked', to: 'woeid#booked'
    get '/woeid/:id/give/status/delivered', to: 'woeid#delivered'

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

    # TODO: messaging
    # /es/message/create/id_user_to/42825/subject/mueble-de-salon

    # TODO: rss
    # /es/rss/feed/woeid/766273/ad_type/give

    # TODO: page
    # /es/page/faqs

    # TODO: contact
    # /es/contact

  end

end
