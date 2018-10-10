require "application_system_test_case"

class CalendarEventsTest < ApplicationSystemTestCase
  setup do
    @calendar_event = calendar_events(:one)
  end

  test "visiting the index" do
    visit calendar_events_url
    assert_selector "h1", text: "Calendar Events"
  end

  test "creating a Calendar event" do
    visit calendar_events_url
    click_on "New Calendar Event"

    fill_in "Agent", with: @calendar_event.agent_id
    fill_in "Calendly", with: @calendar_event.calendly_id
    fill_in "Confirmed At", with: @calendar_event.confirmed_at
    fill_in "Description", with: @calendar_event.description
    fill_in "End Time", with: @calendar_event.end_time
    fill_in "Follow Up Boss", with: @calendar_event.follow_up_boss_id
    fill_in "Google", with: @calendar_event.google_id
    fill_in "Invitees", with: @calendar_event.invitees
    fill_in "Start Time", with: @calendar_event.start_time
    fill_in "Title", with: @calendar_event.title
    click_on "Create Calendar event"

    assert_text "Calendar event was successfully created"
    click_on "Back"
  end

  test "updating a Calendar event" do
    visit calendar_events_url
    click_on "Edit", match: :first

    fill_in "Agent", with: @calendar_event.agent_id
    fill_in "Calendly", with: @calendar_event.calendly_id
    fill_in "Confirmed At", with: @calendar_event.confirmed_at
    fill_in "Description", with: @calendar_event.description
    fill_in "End Time", with: @calendar_event.end_time
    fill_in "Follow Up Boss", with: @calendar_event.follow_up_boss_id
    fill_in "Google", with: @calendar_event.google_id
    fill_in "Invitees", with: @calendar_event.invitees
    fill_in "Start Time", with: @calendar_event.start_time
    fill_in "Title", with: @calendar_event.title
    click_on "Update Calendar event"

    assert_text "Calendar event was successfully updated"
    click_on "Back"
  end

  test "destroying a Calendar event" do
    visit calendar_events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Calendar event was successfully destroyed"
  end
end
