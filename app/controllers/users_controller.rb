class UsersController < ApplicationController

  # Receive information from the sessions login form, create a new user, then render their dashboard
  post '/users' do
    # Create user object based on params passed in from new user form
    @user = User.new
    @user.update(params[:user])
    # Validate params using ActiveRecord validations
    if @user.errors[:email].any?
      flash[:alert] = "There is already an account associated with this email address."
      redirect "/"
    elsif @user.errors[:password].any?
      flash[:alert] = "Your password must be between 6 and 20 characters long."
      redirect "/"
    else
    # Log user in
    session[:user_id] = @user.id
    # Redirect
    redirect "/users/#{@user.id}"
    end
  end

  # Display the current user's information, medications, and reactions
  get '/users/:id' do
    @user = User.find_by(id: params[:id])
    user_stray
    # Make sure the user exists in the current user is trying to view their own info
    if @user && @user.id == current_user.id
      @current_meds = Medication.where(user_id: current_user.id).current.newest_first
      erb :'/users/user_dashboard'
    end
  end

  # Render the user edit form for the current user
  get '/users/:id/edit' do
    @user = User.find_by(id: params[:id])
    user_stray
    # Make sure the user exists in the current user is trying to edit their own info
    if @user && @user.id == current_user.id
      erb :'/users/edit_user'
    end
  end

  # Receive information from the user edit form, update the user, then render their dashboard
  patch '/users/:id' do
    @user = User.find_by(id: params[:id])
    user_stray
    @user.update(params[:user])
    redirect "/users/#{@user.id}"
  end

  ## ========== HELPER METHODS ========== ##

  def user_stray
    if !logged_in? || @user == nil
      flash[:alert] = "You have been logged out of your session. Please log back in to continue."
      redirect "/"
    elsif @user.id != current_user.id
      flash[:alert] = "You do not have permission to view or edit other users' content."
      redirect "/"
    end
  end

end