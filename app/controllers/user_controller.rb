class UserController < ApplicationController
	def new
		@user = User.new
		@decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
	end

	def index
		@decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
	end

	def add_member
		@decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
	end

	def member_selection
		@decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
	end

	def member_chosen
		@decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
		@user = User.find(params[:user_id])
		log_in(@user)
		redirect_to decisionroom_path(@decisionroom), notice: "Welcome! Start participating"
	end

	def create
		@decisionroom = Decisionroom.find_by(token: params[:decisionroom_token])
		@user = User.create(user_params)
		@user.has_voted = false
		@user.decisionroom_id = @decisionroom.id
		
		if @user.save
			log_in(@user)
      		redirect_to decisionroom_path(@decisionroom), notice: "Welcome! Start with the creation process"
    	else
      		@errors = @user.errors.full_messages
      		render:new
    	end
	end

	def destroy
		User.find_by(id: params[:user_id]).destroy
		flash[:notice] = "Decisionmaker is deleted"
		redirect_to decisionroom_path(token: params[:decisionroom_token])

	end

	def user_params
		params.require(:user).permit(:name, :email, :has_voted, :decisionroom_id)
	end
end
