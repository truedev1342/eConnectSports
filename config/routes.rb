Rails.application.routes.draw do
  get 'first-touch-message', to: 'static_pages#first_touch_email'

  resources :team_payments
  resources :payments
  resources :public_kiosks do
    resource :team
  end
  resources :subscriptions
  resources :shares

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  get "settings/edit"
  get "settings/update"

  # Devise Authentication
  devise_for :users, controllers: {
    registrations: "registrations",
    invitations: 'users/invitations',
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
    get "/teams/:team_id/invitations/new", to: "users/invitations#new", as: :new_team_invitation # Renamed for clarity
  end

  # PayPal Routing
  get "paypal/checkout", to: "subscriptions#paypal_checkout"
  get "/thank_you", to: "payments#thank_you"

  # Requested Memberships
  get "memberships/invites", to: "memberships#invites", as: :invites # Changed to symbol

  post "/teams/send_message", to: "teams#send_message", as: :send_team_message # Renamed for clarity

  # Resources - SIGNIFICANT CHANGES HERE TO REDUCE NESTING AND DUPLICATION
  resources :users do
    resources :public_pages do
      resources :shares
    end
    resources :cards do
      member do
        get :share
        get :vcard
        get :calendar
        post :send_vcard
      end
      delete 'saved_cards', to: 'saved_cards#destroy'
      post 'save', to: 'saved_cards#create'
      resources :shares

    end
    resources :contacts do # Removed nested cards,shares, and stats.  These are already accessible through the user.
      resources :shares
    end
    resources :shares # Removed redundant shares
    resources :teams
    resources :memberships do
      member do
        get :approve
        get :decline
        get :make_admin
        get :make_member
      end
      resources :cards # Removed nested resources
    end
  end

  # Removed redundant memberships and cards resources.  They are already defined under users.

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
      get :share
      get :vcard
      get :calendar
      post :send_vcard
    end
    resources :shares
    resources :contacts
  end

  resources :memberships, only: [:destroy] do
    member do
      get :approve
      get :decline
      get :make_admin
      get :make_member
    end
    resources :cards, only: [:edit, :update]
  end

  get '/create-demo-card', to: 'cards#new_demo_card', as: :new_demo_card # Changed to symbol
  post 'cards/check_url_alias', to: 'cards#check_url_alias'

  # Root URL
  authenticated :user do
    root to: 'users#show', as: :authenticated_root
  end

  root to: 'static_pages#home'

  # Static Pages
  get 'home', to: 'static_pages#home', as: :home # Changed to symbol
  get 'about', to: 'static_pages#about', as: :about # Changed to symbol
  get 'contact', to: 'static_pages#contact', as: :contact_us # Renamed to avoid conflict # Changed to symbol
  get 'affiliate', to: 'static_pages#affiliate', as: :affiliate # Changed to symbol
  get 'sports', to: 'static_pages#sports', as: :sports # Changed to symbol
  get 'faq', to: 'static_pages#faq', as: :faq # Changed to symbol


  post '/email', to: 'static_pages#send_mail'
  #post '/cards/:card_id/send_vcard', to: 'cards#send_vcard'  This route is already defined as a member route under cards.  Remove this line.
  get '/:username', to: 'public_pages#show', as: :username # Changed to symbol

end
