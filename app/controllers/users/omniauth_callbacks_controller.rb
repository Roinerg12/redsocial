class Users::OmniauthCallbacksController < ApplicationController
  def facebook
    
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      
      @user.remember_me = true
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      render :edit
    end
  end

  #   @user = User.from_omniauth(request.env["omniauth.auth"])

  #   if @user.persisted?
  #     sign_in_and_redirect @user, :event => :authentication
  #     set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  #   else
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

  def failure
     redirect_to root_path
  end
  
  def custom_sign_up
    @user = User.from_omniauth(session["devise.facebook_data"])
    if @user.update(user_params)
      sign_in_and_redirect @user, event: :authentication
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :username)
    end
    
end