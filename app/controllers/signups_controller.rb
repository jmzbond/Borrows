class SignupsController < ApplicationController

	def new
		@signup = Signup.new
		render layout: false
		
	end

	def create
		@signup = Signup.new(signup_params)
		if @signup.save
			@signup.save_subscrip
			#@signup.add_subscrip
			Subscribe.notification_email(@signup).deliver
			flash[:success] = "Many thanks for your support. You'll hear from us soon!"
			redirect_to new_signup_path, layout: false
		else
			render new_signup_path, layout: false
		end

	end


private

def signup_params 
	params.require(:signup).permit(:email, :name, :heard) 
end

end
