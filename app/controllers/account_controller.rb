class AccountController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard'

  def index
    render :index
  end

  def email
    render :update_email
  end

  def password
    render :update_password
  end

  def payment
    render :update_payment
  end

  def update_email

    @user = current_user
    valid_password = @user.valid_password?((params[:current_user][:password]).to_s)

    if valid_password
      if @user.update_attributes(email_params)
        puts "test again" + (valid_password).to_s
        redirect_to :back, :notice => "User updated."
      end
    else
      redirect_to :back, :alert => "Password incorrect"
    end

  end

  def update_password

    @user = current_user
    @password = params[:password]

      if @user.update_with_password(password_params)
        bypass_sign_in(@user)
        redirect_to :back, :notice => "Password updated."
      else
        redirect_to :back, :alert => "Passwords do not match or too short."
      end

  end

  def update

    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to :back, :notice => "User updated."
    else
      redirect_to :back, :alert => "Sorry an error occured!"
    end

  end

  private

  def user_params
      params.require(:current_user)
      .permit(:first_name, :last_name,
              :phone, :attn_name, :company_name,
              :company_address, :has_auto_reload,
              :auto_reload_amount, :auto_reload_trigger_amount)
  end

  def email_params
      params.require(:current_user)
      .permit(:email, :password)
  end

  def password_params
    params.require(:current_user).permit(:password, :password_confirmation, :current_password)
  end

end
