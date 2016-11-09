class Admin::HomeController < Admin::BaseController
  def index
    @users = User.count
  end
end

