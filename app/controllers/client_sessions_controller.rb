# frozen_string_literal: true

# Controller to handle REST-ful requests for Client
class ClientSessionsController < ApplicationController
  before_action :set_client_session, only: %i[show edit update destroy]

  # @todo authorization should occur on every request.
  after_action :verify_authorized, except: %i[index show]

  # GET /clients or /clients.json
  def index
    client_sessions = ClientSession.all

    render inertia: 'ClientSessions/Index', props: { client_sessions: ClientSessionSerializer.render_as_json(client_sessions) }
  end

  # GET /clients/1 or /clients/1.json
  def show
    render inertia: 'ClientSessions/Show', props: { client_session: ClientSessionSerializer.render_as_json(@client_session) }
  end

  # GET /clients/new
  def new
    authorize ClientSession

    render inertia: 'ClientSessions/New',
           props: { clients: ClientSerializer.render_as_json(Client.order(:name), view: :short_details) }
  end

  # GET /clients/1/edit
  def edit
    render inertia: 'ClientSessions/Edit', props: { client_session: ClientSessionSerializer.render_as_json(@client_session) }
  end

  # POST /clients or /clients.json
  def create
    client_session = ClientSession.new(client_session_params)

    # we don't run set_clients for create, so we need to authorize the resource here
    authorize client_session

    if client_session.save
      redirect_to client_session_path, notice: 'Client session created.'
    else
      redirect_to new_client_session_path, inertia: { errors: client_session.errors }
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    if @client_session.update(client_session_params)
      redirect_to client_path(@client_session), notice: 'Client session was successfully updated.'
    else
      redirect_to edit_client_path(@client_session), inertia: { errors: @client_session.errors }
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    if @client_session.destroy
      redirect_to client_sessions_path, notice: 'Client session was successfully destroyed.'
    else
      redirect_to client_sessions_path, alert: 'Client session cannot be deleted!'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client_session
    @client_session = ClientSession.find(params[:id])

    # we authorize the resource here so all actions that depends on set_client can use it as authorized
    authorize @client_session
  rescue ActiveRecord::RecordNotFound
    redirect_to client_sessions_path
  end

  # Only allow a list of trusted parameters through.
  def client_session_params
    updated_params = params.require(:client_session).permit!
    updated_params[:current_rate] =
      Money.from_amount(updated_params[:current_rate][:amount], updated_params[:current_rate][:currency])
    updated_params
  end
end
