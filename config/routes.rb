NolotiroOrg::Application.routes.draw do

  root 'ads#index'

  # TODO: i18n
  scope '/es' do

    # ads
    get '/', to: 'ads#index'
    resources :ads, path: 'ad', path_names: {
      new: 'create'
    }

    # locations lists
    get '/woeid/:id/:type', to: 'woeid#show', as: 'woeid'

    # location change
    get '/location/change', to: 'location#ask'
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

    # TODO: messaging

  end

end
