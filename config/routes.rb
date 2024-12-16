Players::Application.routes.draw do

  get 'first-touch-message', to: 'static_pages#first_touch_email'

  resources :team_payments


  resources :stats

  resources :payments

  resources :public_kiosks do
    resource :team
  end

  resources :contacts

  resources :subscriptions
  resources :shares

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  get "settings/edit"
  get "settings/update"

  # Devise Authentication
  # devise_for :users, :controllers => { :registrations => "registrations" }
  # devise_for :users, :controllers => { :invitations => 'users/invitations', :omniauth_callbacks => "users/omniauth_callbacks" }
  # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # devise_scope :user do
  #  get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  #  get "/teams/:team_id/invitations/new", :to => "users/invitations#new", as: :team_id
  # end

  # Devise Authentication
  devise_for :users, :controllers => {:registrations => "registrations", :invitations => 'users/invitations', :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
    get "/teams/:team_id/invitations/new", :to => "users/invitations#new", as: :team_id
  end

  # PayPal Routing
  get "paypal/checkout", to: "subscriptions#paypal_checkout"
  get "/thank_you", to: "payments#thank_you"
  # Requested Memberships
  get "memberships/invites", to: "memberships#invites", as: 'invites'

  post "/teams/send_message", to: "teams#send_message", as: "send_message"

  # Resources
  resources :users do
    resources :public_pages do
      resources :shares
    end
    resources :cards do
      member do
        get 'share'
        get 'vcard'
        get 'calendar'
        post 'send_vcard'
      end
      delete    'saved_cards' => 'saved_cards#destroy'
      post      'save'       => 'saved_cards#create'
      resources :card_phones
      resources :card_websites
      resources :shares
      resources :stats
    end
    resources :contacts do
      resources :cards do
        member do
          get 'share'
          get 'vcard'
          get 'calendar'
          post 'send_vcard'
        end
        resources :card_phones
        resources :card_websites
        resources :shares
        resources :stats
      end
    end
    resources :shares
    resources :teams
    resources :memberships do
      member do
        get 'approve'
        get 'decline'
        get 'make_admin'
        get 'make_member'
      end
      resources :cards
    end
  end

  resources :memberships do
    member do
      get 'approve'
      get 'decline'
      get 'make_admin'
      get 'make_member'
    end
    resources :users
    resources :cards do
      resources :card_phones
      resources :card_websites
      resources :shares
      resources :stats
    end
  end

  resources :teams do
    resources :users
    resources :cards
    resources :team_payments
    resource :public_kiosk
  end

  resources :public_pages do
    resources :shares
  end

  resources :cards do
    member do
      get 'share'
      get 'vcard'
      get 'calendar'
      post 'send_vcard'
    end
    resources :card_phones
    resources :card_websites
    resources :shares
    resources :stats
  end

  get '/create-demo-card', to: 'cards#new_demo_card', as: 'new_demo_card'
  post 'cards/check_url_alias', to: 'cards#check_url_alias'

  # Root URL
  authenticated :user do
    root :to => 'users#show'
  end
  root :to => 'static_pages#home'

  # Static Pages
  get 'home', to: 'static_pages#home', as: 'home'
  get 'about', to: 'static_pages#about', as: 'about'
  get 'contact', to: 'static_pages#contact', as: 'contact'
  get 'affiliate', to: 'static_pages#affiliate', as: 'affiliate'
  get 'sports', to: 'static_pages#sports', as: 'sports'
  get 'faq', to: 'static_pages#faq', as:'faq'
  match '/email' => 'static_pages#send_mail'

  # Email vCard
  match '/cards/:card_id/send_vcard' => 'cards#send_vcard'

  # Friendly URL
  match "/:username" => "public_pages#show", as: :username

end
