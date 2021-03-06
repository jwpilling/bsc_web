require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:admin)
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { name: '', password: '' }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid information followed by logout' do
    get login_path
    post login_path, session: { name: @user.name, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash.empty?
    #assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'login updates last_login attribute' do
    get login_path
    post login_path, session: { name: @user.name, password: 'password' }
    assert is_logged_in?
    delete logout_path
    assert_not_equal @user.last_login, @user.reload.last_login do
      get login_path
      post login_path, session: { name: @user.name, password: 'password' }
    end
  end
end
