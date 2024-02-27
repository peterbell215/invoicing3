# frozen_string_literal: true

# Controller to handle REST-ful requests for Client
class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[show edit update destroy]

  # @todo authorization should occur on every request.
  after_action :verify_authorized, except: %i[index show]

  # GET /clients or /clients.json
  def index
    meetings = Meeting.all

    render inertia: 'Meetings/Index', props: { meetings: MeetingSerializer.render_as_json(meetings) }
  end

  # GET /clients/1 or /clients/1.json
  def show
    render inertia: 'Meetings/Show', props: { meeting: MeetingSerializer.render_as_json(@meeting) }
  end

  # GET /clients/new
  def new
    authorize Meeting

    render inertia: 'Meetings/New',
           props: { clients: ClientSerializer.render_as_json(Client.order(:name), view: :short_details) }
  end

  # GET /clients/1/edit
  def edit
    render inertia: 'Meetings/Edit', props: { meeting: MeetingSerializer.render_as_json(@meeting) }
  end

  # POST /clients or /clients.json
  def create
    meeting = Meeting.new(meeting_params)

    # we don't run set_clients for create, so we need to authorize the resource here
    authorize meeting

    if meeting.save
      redirect_to meeting_path, notice: 'Meeting created.'
    else
      redirect_to new_meeting_path, inertia: { errors: meeting.errors }
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    if @meeting.update(meeting_params)
      redirect_to client_path(@meeting), notice: 'Meeting was successfully updated.'
    else
      redirect_to edit_client_path(@meeting), inertia: { errors: @meeting.errors }
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    if @meeting.destroy
      redirect_to meeting_path, notice: 'Meeting was successfully destroyed.'
    else
      redirect_to meetings_path, alert: 'Meeting cannot be deleted!'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_meeting
    @meeting = Meeting.find(params[:id])

    # we authorize the resource here so all actions that depends on set_client can use it as authorized
    authorize @meeting
  rescue ActiveRecord::RecordNotFound
    redirect_to meetings_path
  end

  # Only allow a list of trusted parameters through.
  def client_params
    updated_params = params.require(:client).permit!
    if updated_params[:new_rate].present?
      updated_params[:new_rate] =
        Money.from_amount(updated_params[:new_rate][:amount], updated_params[:new_rate][:currency])
    end
    updated_params
  end
end
