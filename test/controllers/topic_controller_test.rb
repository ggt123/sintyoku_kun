require 'test_helper'

class TopicControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get topic_top_url
    assert_response :success
  end

end
