require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def valid_attributes(overrides = {})
    {
      email: 'new_user@test.com',
      username: 'new_user',
      first_name: 'new',
      last_name: 'user',
      password: 'password123',
      password_confirmation: 'password123'
    }.merge(overrides)
  end

  test 'a complete set of attributes is valid' do
    assert User.new(valid_attributes).valid?
  end

  test 'first_name is required' do
    user = User.new(valid_attributes(first_name: nil))
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :first_name
  end

  test 'last_name is required' do
    user = User.new(valid_attributes(last_name: nil))
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :last_name
  end

  test 'username is required' do
    user = User.new(valid_attributes(username: nil))
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :username
  end

  test 'email must be unique regardless of case' do
    user = User.new(valid_attributes(email: users(:one).email.upcase))
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :email
  end

  test 'username must be unique regardless of case' do
    user = User.new(valid_attributes(username: users(:one).username.upcase))
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :username
  end

  test 'name is an alias for first_name' do
    assert_equal users(:one).first_name, users(:one).name
  end

  test 'full_name capitalises both names' do
    assert_equal 'Test One', users(:one).full_name
  end

  test 'full_name is blank when a name part is missing' do
    assert_equal '', User.new(first_name: 'test').full_name
    assert_equal '', User.new(last_name: 'one').full_name
    assert_equal '', User.new.full_name
  end

  test 'admin? is false for a regular address' do
    assert_not users(:one).admin?
  end

  test 'admin? matches the allow list case insensitively' do
    assert User.new(email: 'Example@Email.com').admin?
  end

  test 'has many cards' do
    assert_includes users(:one).cards, cards(:one)
  end

  test 'has many teams through memberships' do
    assert_includes users(:one).teams, teams(:one)
  end

  test 'has one public page' do
    assert_equal public_pages(:one), users(:one).public_page
  end
end
