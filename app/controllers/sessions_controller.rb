class SessionsController < ApplicationController
  def new
  end

  def create
  	render 'new'
  	user = User.find_by(email: params[:session][:email].downcase)
  		if user && user.authenticate(params[:session][:password])
  			# Log the user in and redirect to the user's show page.
  		else
  			# Flash an error message.
  			render 'new'
  		end
  end

  def destroy
  end
end
