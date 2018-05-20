Rails.application.routes.draw do

  root to: "welcome#index"
  resources :user
  resources :decisionroom, param: :token do
  	  patch :sort
  	  # Decision Creation
      get 'new_ranks'
      get 'new_ranks_not_sorted'
  	  get 'new_votes'

      # User Creation
      get 'user/member_selection'
      get 'user/new_member'
      get 'user/member_chosen'
      get 'user/add_member'
      resources :user

      # Teamoutcome Creation
  	  resources :teamoutcome
      resources :first_decision_analysis
  	end
  	
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
