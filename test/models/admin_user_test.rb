require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
  test 'an email and password make a valid admin' do
    admin = AdminUser.new(email: 'fresh_admin@test.com', password: 'password123',
                          password_confirmation: 'password123')
    assert admin.valid?
  end

  test 'email is required' do
    admin = AdminUser.new(password: 'password123', password_confirmation: 'password123')
    assert_not admin.valid?
    assert_includes admin.errors.attribute_names, :email
  end

  test 'email must be unique' do
    admin = AdminUser.new(email: admin_users(:one).email, password: 'password123',
                          password_confirmation: 'password123')
    assert_not admin.valid?
    assert_includes admin.errors.attribute_names, :email
  end

  test 'the fixture password authenticates' do
    assert admin_users(:one).valid_password?('password123')
    assert_not admin_users(:one).valid_password?('wrong')
  end

  test 'ransackable_attributes does not expose the password digest' do
    assert_not_includes AdminUser.ransackable_attributes, 'encrypted_password'
  end
end
