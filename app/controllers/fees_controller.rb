# frozen_string_literal: true

# Controller to handle REST-ful requests for Fees
class FeesController < ApplicationController
  before_action :set_client

  # @todo Add authorization
  # after_action :verify_authorized

  # GET /clients or /clients.json
  def index
    fees = @client.fees.all

    render inertia: 'Fees/Index',
           props: { client: ClientSerializer.render_as_json(@client),
                    fees: FeeSerializer.render_as_json(fees) }
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params.require(:fee).permit!
  end
end
