NolotiroOrg::Application.routes.draw do

  root 'ads#index'

  scope '/es' do

    get '/', to: 'ads#index'

    resources :ads, path: 'ad', path_names: {
      new: 'create'
    }

    get '/woeid/:id/:type', to: 'woeid#show'

    get '/auth/login', to: redirect('/es/user/login')

    # Authentication
    devise_for :users, path: 'user', path_names: {
      sign_up: 'register',
      sign_in: 'login',
      sign_out: 'logout',
      password: 'reset'
    }

  end

end
