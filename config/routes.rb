PostitTemplate::Application.routes.draw do
  root to: 'posts#index'
  resources :posts, except: :destroy do
    resources :comments, only: :create
  end
  resources :categories, only: [:create, :new, :show]
  resources :post_categories, only: [:create]
end
