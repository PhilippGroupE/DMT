module SessionsHelper
	def log_in(user)
		session[:user_id] = user.id
	end	

	def current_user
   		@current_user ||= User.find_by(id: session[:user_id])
  	end

  	def logged_in?()
  		if current_user.nil? then
  			@decisionroom = Decisionroom.find_by(token: params[:token])
  			redirect_to decisionroom_user_member_selection_path(decisionroom_token: @decisionroom.token)
  		end
  	end
end
