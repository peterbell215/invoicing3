# frozen_string_literal: true

# Called for front end static page.
class StaticController < ApplicationController
  def home
    render inertia: 'App'
  end
end
