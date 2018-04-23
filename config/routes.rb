Rails.application.routes.draw do

  root to: "welcome#index"
  resources :user
  resources :decisionroom, param: :token do
  	  patch :sort
  	  get 'new_ranks'
      get 'new_ranks_not_sorted'
  	  get 'new_votes'
      get 'user/member_selection'
      get 'user/new_member'
      get 'user/member_chosen'
      get 'user/add_member'
      resources :user
  	  resources :teamoutcome
  	end
  	
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
