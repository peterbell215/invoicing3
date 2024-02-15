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
           props: { client: @client.as_json(only: [:id, :name]), prices: prices.map(&:json_with_dinero) }
  end

=begin
  # @todo
  # GET /clients/1 or /clients/1.json
  def show
    render inertia: 'Clients/Show', props: { client: @client.as_json }
  end

  # GET /clients/new
  def new
    authorize Client

    render inertia: 'Clients/New'
  end

  # GET /clients/1/edit
  def edit
    render inertia: 'Clients/Edit', props: { client: @client.as_json }
  end

  # POST /clients or /clients.json
  def create
    client = Client.new(client_params)

    # we don't run set_clients for create, so we need to authorize the resource here
    authorize client

    if client.save
      redirect_to clients_path, notice: 'Client created.'
    else
      redirect_to new_client_path, inertia: { errors: client.errors }
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    if @client.update(client_params)
      redirect_to client_path(@client), notice: 'Client was successfully updated.'
    else
      redirect_to edit_client_path(@client), inertia: { errors: @client.errors }
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    if @client.destroy
      redirect_to clients_path, notice: 'Client was successfully destroyed.'
    else
      redirect_to clients_path, alert: 'Client cannot be deleted!'
    end
  end
=end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end


  # Only allow a list of trusted parameters through.
  def client_params
    params.require(:price).permit!
  end
end

