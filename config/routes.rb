# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  scope '/api' do
    scope '/v1' do
      get '/ad/:id', format: 'json', to: 'api/v1#ad_show', as: 'apiv1_ad_show'
      get '/woeid/:id/:type', format: 'json', to: 'api/v1#woeid_show', as: 'apiv1_woeid_show'
      get '/woeid/list', format: 'json', to: 'api/v1#woeid_list', as: 'apiv1_woeid_list'
    end
  end

  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'callbacks' }

  constraints locale: /#{I18n.available_locales.join("|")}/ do
    get '/locales/:locale', to: 'locales#show', as: :locale

    # i18n
    scope '(:locale)' do
      root 'woeid#show', defaults: { type: 'give' }

      # FIXME: type on ads#create instead of params
      resources :ads, path: 'ad',
                      path_names: { new: 'create' },
                      except: %i[index show] do
        resources :comments, only: :create
        resources :reports, only: %i[new create]
      end

      scope '/ad' do
        get '/:id/:slug', to: 'ads#show', as: 'adslug'
        get '/edit/id/:id', to: 'ads#edit', as: 'ads_edit'
        post '/bump/id/:id', to: 'ads#bump', as: 'ads_bump'
        post '/change_status/id/:id',
             to: 'ads#change_status',
             as: 'ads_change_status'
        constraints(FullListConstraint.new) do
          get '/listall/ad_type/:type(/status/:status)(/page/:page)',
              to: 'woeid#show',
              as: 'ads_listall'
        end

        get '/listuser/id/:username(/type/:type)(/status/:status)(/page/:page)',
            to: redirect(ProfileUrlRewriter.new),
            constraints: { username: %r{[^/]+} }
      end

      # locations lists
      get '/woeid/:id/:type(/status/:status)(/page/:page)',
          to: 'woeid#show',
          as: 'ads_woeid',
          constraints: WoeidListConstraint.new

      # location change
      scope '/location' do
        get  '/change', to: 'location#ask', as: 'location_ask'
        get  '/change2', to: 'location#change', as: 'location_change'
        post '/change', to: 'location#list'
        post '/change2', to: 'location#change'
      end

      devise_for :users,
                 skip: %i[omniauth_callbacks unlocks],
                 controllers: { registrations: 'registrations' },
                 path: 'user',
                 path_names: {
                   sign_up: 'register',
                   sign_in: 'login',
                   sign_out: 'logout',
                   password: 'reset'
                 }

      # friendships
      resources :friendships, only: %i[create destroy]

      scope '/admin' do
        authenticate :user, ->(u) { u.admin? } do
          mount Sidekiq::Web, at: '/jobs'
        end
      end

      get '/profile/:username(/type/:type)(/status/:status)(/page/:page)',
          to: 'users#profile',
          as: 'profile',
          constraints: { username: %r{[^/]+} }

      # blocking
      resources :blockings, only: %i[create destroy]

      # messaging
      resources :conversations do
        member { delete 'trash' }
        collection { delete 'trash' }
      end

      # rss
      # nolotirov2 - legacy
      # FIX: las URLs legacy vienen asi
      # /en                     /rss/feed/woeid/766273                     /ad_type/give
      # Lo solucionamos en el nginx.conf y una configuracion para hacer el search and replace
      # http://stackoverflow.com/questions/22421522/nginx-rewrite-rule-for-replacing-space-whitespace-with-hyphen-and-convert-url-to
      scope '/rss' do
        get '/feed/woeid/:woeid/ad_type/:type', format: 'rss', to: 'rss#feed', as: 'rss_type'
      end

      scope '/page' do
        get '/faqs', to: 'page#faqs', as: 'faqs'
        get '/rules', to: 'page#rules', as: 'rules'
        get '/about', to: 'page#about', as: 'about'
        get '/privacy', to: 'page#privacy', as: 'privacy'
        get '/legal', to: 'page#legal', as: 'legal'
        get '/translate', to: 'page#translate', as: 'translate'
      end

      # contact
      get '/contact', to: 'contact#new', as: 'contacts'
      post '/contact', to: 'contact#create'

      # dismissing
      resources :announcements, only: [] do
        resources :dismissals, only: :create
      end
    end
  end
end
