Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	resources :users, only: [:create, :update] do
	#resources :users do

		member do
			post :info
		end
		collection do
			post :unique_username
			post :unique_email
            post :login
		end
	end

	resources :comments, only: [:create] do
	end

	
	get 'total', to: 'items#total'

	resources :items, only: [:create, :update, :index, :show] do
		member do
#			get :filtered_list
		end
		collection do
#			get :filtered_list
			post :filtered_list
		end
	end

# do
#		collection do
#		end
#		member do
#			get :show
#			get :create
#			get :destroy
#			get :edit
#			get :index
#			get :new
#			get :update
#			post :update
#			post :edit
#		end
#	end

end
