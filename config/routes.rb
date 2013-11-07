NolotiroOrg::Application.routes.draw do

  root 'ads#index'

  scope '/es' do
    resources :ads
    get '/woeid/:id/:type', to: 'woeid#show'
  end

end
