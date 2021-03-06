class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_navbar_items

  rescue_from Swarm::SpiderDownloadFailure, with: :spider_failure

  private

  def set_navbar_items
    @navbar_items = []
  end

  def spider_failure(exception)
    # TODO: send email notification
    render plain: "Unable to download data from #{exception.message}"
  end
end
