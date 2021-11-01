require "test_helper"

class InoculationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inoculation = inoculations(:one)
  end

  test "should get index" do
    get inoculations_url
    assert_response :success
  end

  test "should get new" do
    get new_inoculation_url
    assert_response :success
  end

  test "should create inoculation" do
    assert_difference('Inoculation.count') do
      post inoculations_url, params: { inoculation: { appointement_at: @inoculation.appointement_at, country_id: @inoculation.country_id, fulfilled: @inoculation.fulfilled, mandatory: @inoculation.mandatory, user: @inoculation.user, vaccine_id: @inoculation.vaccine_id } }
    end

    assert_redirected_to inoculation_url(Inoculation.last)
  end

  test "should show inoculation" do
    get inoculation_url(@inoculation)
    assert_response :success
  end

  test "should get edit" do
    get edit_inoculation_url(@inoculation)
    assert_response :success
  end

  test "should update inoculation" do
    patch inoculation_url(@inoculation), params: { inoculation: { appointement_at: @inoculation.appointement_at, country_id: @inoculation.country_id, fulfilled: @inoculation.fulfilled, mandatory: @inoculation.mandatory, user: @inoculation.user, vaccine_id: @inoculation.vaccine_id } }
    assert_redirected_to inoculation_url(@inoculation)
  end

  test "should destroy inoculation" do
    assert_difference('Inoculation.count', -1) do
      delete inoculation_url(@inoculation)
    end

    assert_redirected_to inoculations_url
  end
end
