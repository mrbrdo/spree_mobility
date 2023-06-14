Spree::Core::Engine.add_routes do
  namespace :admin, path: Spree.admin_path do
    get '/translations/:resource/:resource_id' => 'translations#index', as: :translations
    post '/translations/:resource/:resource_id' => 'translations#update', as: :update_translation
  end
end
