require 'test_helper'

class ZuluCControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get zulu_c_index_url
    assert_response :success
  end

end
