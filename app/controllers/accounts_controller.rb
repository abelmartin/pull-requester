class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def update
    current_user.update_attributes(acceptable_user_params)
    render :show
  end

  private

  def acceptable_user_params
    params.require(:user).permit(:name, :verbose)
  end
end
