require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
	assert @user.valid?  	
  end

  test "name should be present" do
  	@user.name = "      "
  	assert_not @user.valid?
  end

  test "email should be present" do
  	@user.email = ""
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = "thisIsAnExampleNameThatShouldBeWayTooLongForValidation"
  	assert_not @user.valid?
  end

  test "email should not be over 255 characters" do
  	@user.email = "a" * 256 + "@example.com"
  	assert_not @user.valid?
  end

  test "email should accept the proper format" do
  	valid_addresses = %w[user@example.com A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
	valid_addresses.each do |email|
		@user.email = email
		assert @user.valid?, "#{email.inspect} should be valid"
	end
  end

  test "email should reject improper format" do
  	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com USER@foo..COM]
	invalid_addresses.each do |email|
		@user.email = email
		assert_not @user.valid?, "#{email.inspect} should be invalid"
	end
  end

  test "email addresses should be unique" do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "password should have a minimum length" do
  	@user.password = @user.password_confirmation = "a" * 5
  	assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end
