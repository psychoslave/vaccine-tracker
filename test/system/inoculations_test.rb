require "application_system_test_case"

class InoculationsTest < ApplicationSystemTestCase
  setup do
    @inoculation = inoculations(:one)
  end

  test "visiting the index" do
    visit inoculations_url
    assert_selector "h1", text: "Inoculations"
  end

  test "creating a Inoculation" do
    visit inoculations_url
    click_on "New Inoculation"

    fill_in "Appointement at", with: @inoculation.appointement_at
    fill_in "Country", with: @inoculation.country_id
    check "Fulfilled" if @inoculation.fulfilled
    check "Mandatory" if @inoculation.mandatory
    fill_in "User", with: @inoculation.user
    fill_in "Vaccine", with: @inoculation.vaccine_id
    click_on "Create Inoculation"

    assert_text "Inoculation was successfully created"
    click_on "Back"
  end

  test "updating a Inoculation" do
    visit inoculations_url
    click_on "Edit", match: :first

    fill_in "Appointement at", with: @inoculation.appointement_at
    fill_in "Country", with: @inoculation.country_id
    check "Fulfilled" if @inoculation.fulfilled
    check "Mandatory" if @inoculation.mandatory
    fill_in "User", with: @inoculation.user
    fill_in "Vaccine", with: @inoculation.vaccine_id
    click_on "Update Inoculation"

    assert_text "Inoculation was successfully updated"
    click_on "Back"
  end

  test "destroying a Inoculation" do
    visit inoculations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Inoculation was successfully destroyed"
  end
end
