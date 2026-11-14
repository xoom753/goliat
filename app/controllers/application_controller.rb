class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :restrict_clients!

  private

  def restrict_clients!
    unless Rails.application.config_for(:clients)[:permitted_clients].include?(request.remote_ip)
      Rails.logger.info "== Denied remote ip: #{request.remote_ip}"
      render plain: "", status: :service_unavailable
    end
  end
end
