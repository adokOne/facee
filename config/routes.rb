Facee::Application.routes.draw do
  
  namespace :api do
    namespace :user do 
      %w(authorize list info user_info follow unfollow friend unfriend friends followers following).each do |action|
        match action , :via=>[:get,:post]
      end
    end
    namespace :comment do 
      %w(list post).each do |action|
        match action , :via=>[:get,:post]
      end
    end
    namespace :pictures do 
      %w(list post like strim).each do |action|
        match action , :via=>[:get,:post]
      end
    end
  end



  get 'admin',  to: "admin#index" 
  namespace :admin do
    post "login_admin"
  end


  root :to => 'main#index'




end
