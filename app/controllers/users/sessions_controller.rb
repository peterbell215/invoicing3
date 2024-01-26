# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  # GET /login
  def new
    render inertia: 'Auth/Login', props: {}
  end
end
