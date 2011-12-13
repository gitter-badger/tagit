TagIt::Application.routes.draw do
  get 'sessions/new'

	resources :users do
    member do
      get :following, :followers, :followed_tags
    end
  end
  
  resources :sessions, :only => [:new, :create, :destroy]
  resources :posts, :only => [:create, :show, :edit, :update, :destroy]
  resources :tags, :only => [:show, :destroy]
  
  resources :relationships, :only => [:create, :destroy]
  resources :post_tags, :only => [:create, :destroy]
  resources :user_tags, :only => [:create, :destroy]
  
	root :to => 'pages#home'
  
	match '/signup' => 'users#new'
  match '/signin' => 'sessions#new'
  match '/signout' => 'sessions#destroy'

	match '/contact' => 'pages#contact'
	match '/about' => 'pages#about'
	match '/help' => 'pages#help'
  match '/news' => 'pages#news'
end
