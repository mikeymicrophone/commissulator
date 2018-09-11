require 'test_helper'

class InvolvementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @involvement = involvements(:one)
  end

  test "should get index" do
    get involvements_url
    assert_response :success
  end

  test "should get new" do
    get new_involvement_url
    assert_response :success
  end

  test "should create involvement" do
    assert_difference('Involvement.count') do
      post involvements_url, params: { involvement: { description: @involvement.description, package_id: @involvement.package_id, rate: @involvement.rate, role_id: @involvement.role_id } }
    end

    assert_redirected_to involvement_url(Involvement.last)
  end

  test "should show involvement" do
    get involvement_url(@involvement)
    assert_response :success
  end

  test "should get edit" do
    get edit_involvement_url(@involvement)
    assert_response :success
  end

  test "should update involvement" do
    patch involvement_url(@involvement), params: { involvement: { description: @involvement.description, package_id: @involvement.package_id, rate: @involvement.rate, role_id: @involvement.role_id } }
    assert_redirected_to involvement_url(@involvement)
  end

  test "should destroy involvement" do
    assert_difference('Involvement.count', -1) do
      delete involvement_url(@involvement)
    end

    assert_redirected_to involvements_url
  end
end
