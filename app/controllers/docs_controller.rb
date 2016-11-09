class DocsController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard'

  def index
    @page_is = "DOCS"
    render :index
  end

  def web
    @page_is = "DOCS"
    render :web
  end

  def api
    @page_is = "DOCS"
    render :api
  end

  def android
    @page_is = "DOCS"
    render :android
  end

  def ios
    @page_is = "DOCS"
    render :ios
  end


end
