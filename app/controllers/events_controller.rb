class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update]

  # assumption => owner of an event is an admin which is different from front-end users, it can be changed according to requirements

  # GET /events
  def index
    begin
      events = Event.all
      render :json => {events: ActiveModel::ArraySerializer.new(events, each_serializer: EventsSerializer), :code => 200}, status: :ok
    rescue Exception => e
      logger.error {"Error while populating list of events. ErrorMessage: #{e.message}, Params: #{params.inspect}"}
      render json: {error: e.message, code: 500}
    end
  end

  # GET /events/1
  def show
    begin
      raise 'Event not found' unless @event.present?
      render json: EventSerializer.new(@event).attributes.merge!(code: 200, status: :ok)
    rescue Exception => e
      logger.error {"Error while showing details of an event. ErrorMessage: #{e.message}, Params: #{params.inspect}"}
      render json: {error: e.message, code: 500}
    end
  end

  # POST /create-new-event
  def create_new_event
    begin
      raise 'Required params does not exists' unless create_params_exists? (params)
      user = get_event_owner params[:owner_id]
      raise 'Owner not found' unless user.present?
      raise 'Incorrect Duration' if params[:duration].present? and not duration_whole_number? params[:duration]
      event = Event.create_new_event(event_params)
      if event.present?
        render json: EventSerializer.new(event).attributes.merge!(code: 200, status: :created)
      else
        render json: event.errors, status: :unprocessable_entity, code: 500
      end
    rescue Exception => e
      logger.error {"Error while Creating new event. ErrorMessage: #{e.message}, Params: #{params.inspect}"}
      render json: {error: e.message, code: 500}
    end
  end

  # POST /publish-event
  def publish_event
    begin
      if params[:event_id].present?
        event = Event.where(:id => params[:event_id]).first
        raise 'Event not found' unless event.present?
        raise 'All params are required' unless publish_params_exists? (event)
      else
        raise 'All params are required' unless publish_params_exists? (params)
        user = get_event_owner params[:owner_id]
        raise 'Owner not found' unless user.present?
        event = Event.create_new_event(event_params)
        raise 'Unable to create and publish the event' unless event.present?
      end
      render json: EventSerializer.new(event).attributes.merge!(code: 200, status: :already_published) and return if event.is_published #check if event is already published
      raise 'Incorrect Duration' if params[:duration].present? and not duration_whole_number? params[:duration]
      event.publish_event # publish the event
      render json: EventSerializer.new(event).attributes.merge!(code: 200, status: :published)
    rescue Exception => e
      logger.error {"Error while Publishing Event. ErrorMessage: #{e.message}, Params: #{params.inspect}"}
      render json: {error: e.message, code: 500}
    end
  end

  # POST stop-event
  def stop_event
    begin
      event = Event.find(params[:event_id])
      raise 'Event not found' unless event.present?
      event.stop_event
      render :json => EventSerializer.new(event).attributes.merge!(code: 200, status: :stopped)
    rescue Exception => e
      logger.error {"Error while Stopping an Event. ErrorMessage: #{e.message}, Params: #{params.inspect}"}
      render json: {error: e.message, code: 500}
    end
  end

  # POST delete-event
  def delete_event
    begin
      event = Event.find(params[:event_id])
      raise 'Event not found' unless event.present?
      event.delete_event
      render :json => EventSerializer.new(event).attributes.merge!(code: 200, status: :stopped)
    rescue Exception => e
      logger.error {"Error while Deleting an Event. ErrorMessage: #{e.message}, Params: #{params.inspect}"}
      render json: {error: e.message, code: 500}
    end
  end

  # POST /events/1
  def update
    begin
      raise 'Event not found' unless event.present?
      raise 'Required params does not exists' unless create_params_exists? (params)
      if @event.update(event_params)
        render json: EventSerializer.new(@event).attributes.merge!(code: 200, status: :created)
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    rescue Exception => e
      logger.error {"Error while Updating an Event. ErrorMessage: #{e.message}, Params: #{params.inspect}"}
      render json: {error: e.message, code: 500}
    end
  end

  private

  def duration_whole_number? duration
    duration.present? and duration >= 0 and (duration - duration.to_i == 0)
  end

  def get_event_owner(owner_id)
    User.where(:id => owner_id).first
  end

  def create_params_exists? params
    params[:name].present? and params[:description].present? and params[:start_date].present? and params[:latitude].present? and params[:longitude].present? and params[:owner_id].present?
  end

  def publish_params_exists? params
    (params[:name].present? and params[:description].present? and params[:duration].present? and params[:start_date].present? and params[:latitude].present? and params[:longitude].present? and params[:owner_id].present?)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def event_params
    params.require(:event).permit(:name, :duration, :is_started, :is_completed, :is_published, :is_deleted, :latitude, :longitude, :owner_id, :event_id, :start_date, :description)
  end
end
