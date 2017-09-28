require 'test_helper.rb'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get events_url, as: :json
    assert_response :ok
  end

  test "should show event" do
    get event_detail_url(@event.id), as: :json
    assert_response :ok
  end

  test "should create event" do
    post create_new_event_url, params: {name: @event.name, description: @event.description, start_date: @event.start_date, latitude: @event.latitude, longitude: @event.longitude, owner_id: @event.owner_id}, as: :json
    assert_response 200
  end

  test "should publish event" do
    post create_new_event_url, params: {name: @event.name, description: @event.description, start_date: @event.start_date, latitude: @event.latitude, longitude: @event.longitude, owner_id: @event.owner_id, duration: @event.duration}, as: :json
    assert_response 200
  end

  test "should stop an event" do
    post stop_event_url, params: {event_id: @event.id}, as: :json
    assert_response 200
  end

  test "should delete an event" do
    post delete_event_url, params: {event_id: @event.id}, as: :json
    assert_response 200
  end

  test "should update an event" do
    post delete_event_url(@event.id), params: {id: @event.id}, as: :json
    assert_response 200
  end



end
