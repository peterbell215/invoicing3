# frozen_string_literal: true

# Controller to handle REST-ful requests for Invoices
class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[show edit update destroy]

  # @todo authorization should occur on every request.
  after_action :verify_authorized, except: %i[index show]

  # GET /clients or /clients.json
  def index
    invoices = Invoice.all

    render inertia: 'Invoices/Index', props: { invoices: InvoiceSerializer.render_as_json(invoices) }
  end

  # GET /clients/1 or /clients/1.json
  def show
    render inertia: 'Invoices/Show',
           props: { invoice: InvoiceSerializer.render_as_json(@invoice) }
  end

  # GET /clients/new
  def new
    authorize Invoice

    props = { clients: ClientSerializer.render_as_json(Client.order(:name), view: :short_details) }

    client_id = params.fetch(:client_id, nil)
    if client_id
      client_sessions = ClientSession.where(client_id:, invoice_id: nil)
      props[:client_sessions] = ClientSessionSerializer.render_as_json(client_sessions)
    end

    render inertia: 'Invoices/New', props:
  end

  # GET /clients/1/edit?client_id=13
  def edit
    render inertia: 'Invoices/Edit', props: { client_session: ClientSessionSerializer.render_as_json(@invoice) }
  end

  # POST /clients or /clients.json
  def create
    # we don't run set_clients for create, so we need to authorize the resource here
    authorize Invoice

    invoice = Invoice.create(invoices_params)

    if invoice
      redirect_to client_session_path(invoice), notice: 'Invoice created.'
    else
      redirect_to new_invoice_path, inertia: { errors: invoice.errors }
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    if @invoice.update(invoice_params)
      redirect_to client_path(@invoice), notice: 'Invoice was successfully updated.'
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
  def set_invoice
    @invoice = Invoice.find(params[:id])

    # we authorize the resource here so all actions that depends on set_client can use it as authorized
    authorize @invoice
  rescue ActiveRecord::RecordNotFound
    redirect_to invoices_path
  end

  # Only allow a list of trusted parameters through.
  def invoices_params
    updated_params = params.require(:invoice).permit!
    updated_params[:amount] = Money.from_cents(updated_params[:amount][:amount], updated_params[:amount][:currency])
    updated_params
  end
end
