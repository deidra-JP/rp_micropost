require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
  end                   

  test "associated microposts should be destroyed" do
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
end
