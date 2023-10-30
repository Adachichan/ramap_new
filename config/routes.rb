Rails.application.routes.draw do

  namespace :admin do
    get 'comments/index'
  end
  namespace :admin do
    get 'reviews/index'
    get 'reviews/show'
  end

  #---------------------------------------------------------------------------------------
  # public routes

  # guest_sign_in
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  # URL：/users/sign_in
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  scope module: :public do

    root to: 'homes#top'
    get 'search', to: 'homes#search', as: 'search'
    get 'users/mypage', to: 'users#show', as: 'mypage'
    get 'users/information/edit', to: 'users#edit', as: 'edit_information'
    patch 'users/information', to: 'users#update', as: 'update_information'
    get 'users/unsubscribe', to: 'users#unsubscribe', as: 'unsubscribe'
    patch 'users/withdraw', to: 'users#withdraw', as: 'withdraw'
    get 'mystores/:id/closing_confirm', to: 'mystores#closing_confirm', as: 'closing_confirm'
    patch 'mystores/:id/close', to: 'mystores#close', as: 'close'
    delete 'mystores/:mystore_id/mymenus/destroy_all', to: 'mymenus#destroy_all', as: 'destroy_all_mymenus'
    get 'reviews/history', to: 'reviews#history', as: 'store_review_history'

    resources :stores, only: %i(show) do
      resources :menus, only: %i(index)
      resources :reviews, only: %i(index new create show)
    end

    resources :mystores, only: %i(index new create show edit update) do
      resources :mymenus, only: %i(index create edit update destroy)
    end

    resources :reviews, only: %i() do
      resources :comments, only: %i(create)
      resource :favorites, only: %i(create destroy)
    end

  end

  #---------------------------------------------------------------------------------------
  # admin routes

  # URL：/admin/sign_in
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do

    root to: 'homes#top'

    resources :stores, only: %i(show edit update)

    resources :users, only: %i(index show edit update)

    resources :store_genres, only: %i(index create edit update)

    resources :reviews, only: %i(index show destroy) do
      resources :comments, only: %i(index)
    end

    resources :comments, only: %i(destroy)

  end

end
