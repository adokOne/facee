Facee::Application.routes.draw do
  
  namespace :api do
    namespace :user do 
      %w(authorize list info user_info follow friend friends followers following).each do |action|
        match action , :via=>[:get,:post]
      end
    end
    namespace :comment do 
      %w(list post delete).each do |action|
        match action , :via=>[:get,:post]
      end
    end
    namespace :pictures do 
      %w(list info delete post like strim).each do |action|
        match action , :via=>[:get,:post]
      end
    end
  end



  get 'admin',  to: "admin#index" 
  get 'logout', to: "admin#exit"
  namespace :admin do
    post "login_admin"
    resources :users
    resources :photos
    resources :articles
     get "activity", to: "activity#index"
  end


  root :to => 'main#index'
  match '*a',   :to => 'api/api#routing_error'



end
