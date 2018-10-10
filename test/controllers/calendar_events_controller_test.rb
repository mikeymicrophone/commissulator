require 'test_helper'

class CalendarEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calendar_event = calendar_events(:one)
  end

  test "should get index" do
    get calendar_events_url
    assert_response :success
  end

  test "should get new" do
    get new_calendar_event_url
    assert_response :success
  end

  test "should create calendar_event" do
    assert_difference('CalendarEvent.count') do
      post calendar_events_url, params: { calendar_event: { agent_id: @calendar_event.agent_id, calendly_id: @calendar_event.calendly_id, confirmed_at: @calendar_event.confirmed_at, description: @calendar_event.description, end_time: @calendar_event.end_time, follow_up_boss_id: @calendar_event.follow_up_boss_id, google_id: @calendar_event.google_id, invitees: @calendar_event.invitees, start_time: @calendar_event.start_time, title: @calendar_event.title } }
    end

    assert_redirected_to calendar_event_url(CalendarEvent.last)
  end

  test "should show calendar_event" do
    get calendar_event_url(@calendar_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_calendar_event_url(@calendar_event)
    assert_response :success
  end

  test "should update calendar_event" do
    patch calendar_event_url(@calendar_event), params: { calendar_event: { agent_id: @calendar_event.agent_id, calendly_id: @calendar_event.calendly_id, confirmed_at: @calendar_event.confirmed_at, description: @calendar_event.description, end_time: @calendar_event.end_time, follow_up_boss_id: @calendar_event.follow_up_boss_id, google_id: @calendar_event.google_id, invitees: @calendar_event.invitees, start_time: @calendar_event.start_time, title: @calendar_event.title } }
    assert_redirected_to calendar_event_url(@calendar_event)
  end

  test "should destroy calendar_event" do
    assert_difference('CalendarEvent.count', -1) do
      delete calendar_event_url(@calendar_event)
    end

    assert_redirected_to calendar_events_url
  end
end
