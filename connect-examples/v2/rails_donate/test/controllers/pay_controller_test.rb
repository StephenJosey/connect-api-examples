require 'test_helper'

class PayControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pay_index_url
    assert_response :success
  end

end
