Spree::Core::Engine.routes.draw do
  namespace :spree do
    resources :license_keys
  end


  # Add your extension routes here
end
