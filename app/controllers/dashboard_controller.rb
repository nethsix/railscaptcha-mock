class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard'

  def index
    @page_is = "DASHBOARD"
    free_plan = ServicePlan.find(47)
    @my_apps = current_user.sites 
    @free_remainder = free_plan.max_sms - current_user.user_profile.sms_count
    render :index
  end

end
