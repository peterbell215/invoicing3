# frozen_string_literal: true

# Manages authentication of the session
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include InertiaCsrf
  include InertiaFlash

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  inertia_share auth: -> { { user: current_user.email } if user_signed_in? }

  private

  def user_not_authorized
    redirect_to request.referer || root_path, alert: 'You are not authorized to perform this action.'
  end
end
