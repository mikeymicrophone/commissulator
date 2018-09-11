require "application_system_test_case"

class InvolvementsTest < ApplicationSystemTestCase
  setup do
    @involvement = involvements(:one)
  end

  test "visiting the index" do
    visit involvements_url
    assert_selector "h1", text: "Involvements"
  end

  test "creating a Involvement" do
    visit involvements_url
    click_on "New Involvement"

    fill_in "Description", with: @involvement.description
    fill_in "Package", with: @involvement.package_id
    fill_in "Rate", with: @involvement.rate
    fill_in "Role", with: @involvement.role_id
    click_on "Create Involvement"

    assert_text "Involvement was successfully created"
    click_on "Back"
  end

  test "updating a Involvement" do
    visit involvements_url
    click_on "Edit", match: :first

    fill_in "Description", with: @involvement.description
    fill_in "Package", with: @involvement.package_id
    fill_in "Rate", with: @involvement.rate
    fill_in "Role", with: @involvement.role_id
    click_on "Update Involvement"

    assert_text "Involvement was successfully updated"
    click_on "Back"
  end

  test "destroying a Involvement" do
    visit involvements_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Involvement was successfully destroyed"
  end
end
