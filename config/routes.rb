Rails.application.routes.draw do
    get 'remedies/index'

    # resources :users do
    resources :remedies do
    	resources :presentations
    	collection { post :import }
    end

end
