class Admin::BaseController < ApplicationController
  before_filter :requires_admin

protected
  def requires_admin
    current_user.admin? || not_found
  end
end

