require 'test_helper'

class ItemControllerTest < ActionDispatch::IntegrationTest
  test "should get view" do
    get item_view_url
    assert_response :success
  end

end
