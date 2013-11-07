NolotiroOrg::Application.routes.draw do
  resources :ads

  root 'ads#index'

end
