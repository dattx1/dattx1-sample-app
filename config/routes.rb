Rails.application.routes.draw do
  root "static_pages#home"
  get "users/show"
  get "users/new"
  get  "/help",    to: "static_pages#help"
  get  "/about",   to: "static_pages#about"
  get  "/contact", to: "static_pages#contact"
  get  "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  get "password_resets/new"
  get "password_resets/edit"
  resources :users
  resources :account_activations, only: :edit
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy, :edit, :update]
  resources :relationships, only: [:create, :destroy]
  resources :follow_user, only: :show
 end
