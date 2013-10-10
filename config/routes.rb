Wsn::Application.routes.draw do

  resources :imagens do
    as_routes
    get 'capturar', :on => :collection
  end
  match '/imagens/analizar/:id' => 'imagens#analizar', :as => :analizar_imagenes
  #match '/imagens/capturar/:id' => 'imagens#capturar', :as => :capturar_imagenes

  resources :programas do as_routes end
  match '/programas/enviar/:id' => 'programas#enviar', :as => :enviar_programas
  match '/programas/iniciar/:id' => 'programas#iniciar', :as => :iniciar_programas

  resources :dispositivos do as_routes end

  resources :configuracions do as_routes end

  resources :variables do as_routes end
  resources :datos do as_routes end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'imagens#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  match '/comunicacion/index' => 'comunicacion#index', :as => :otap
  match '/comunicacion/log' => 'comunicacion#log', :as => :log

  match '/otap/index' => 'otap#index', :as => :otap
  match '/otap/discover_devices' => 'otap#discover_devices', :as => :discover
  match '/otap/send_program' => 'otap#send_program', :as => :send_program
  match '/otap/send_start' => 'otap#send_start', :as => :start_program
  match '/otap/log' => 'otap#log', :as => :log

  match '/api/new_data_mote' => "api#new_data_mote", :as => :new_data_mote

  ## delayed_job
  match "/delayed_job" => DelayedJobWeb, :anchor => false

end
