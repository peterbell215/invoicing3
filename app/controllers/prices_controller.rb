# frozen_string_literal: true

# Controller to handle REST-ful requests for Prices
class PricesController < ApplicationController
  before_action :set_client

  # @todo Add authorization
  # after_action :verify_authorized

  # GET /clients or /clients.json
  def index
    prices = @client.prices.all

    render inertia: 'Prices/Index',
           props: { client: @client.as_json(only: %i[id name]), prices: prices.map(&:json_with_dinero) }
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params.require(:price).permit!
  end
end
