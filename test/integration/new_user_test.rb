require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username:"John", email:"john@example.com", password: "password", admin:true)
    @new_user = User.new(username:"Bob", email:"bob@example.com", password: "password")
  end

  test 'valid user created' do
    get signup_path
    assert_template "users/new"
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {username: @new_user.username, email: @new_user.email, password: "password"}
    end
    assert_template 'users/show'
    assert_match @new_user.username, response.body
  end

  test 'short username rejected' do
    get signup_path
    assert_template "users/new"
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: "aa", email: @new_user.email, password: "password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test 'long username rejected' do
    get signup_path
    assert_template "users/new"
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: "a"*26, email: @new_user.email, password: "password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'duplicate username rejected' do
    get signup_path
    assert_template "users/new"
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: @user.username, email: @new_user.email, password: "password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'invalid email rejected' do
    get signup_path
    assert_template "users/new"
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: @new_user.username, email: "notEmail", password: "password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'long email rejected' do
    get signup_path
    assert_template "users/new"
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: @new_user.username, email: "a"*106, password: "password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test 'duplicate email rejected' do
    get signup_path
    assert_template "users/new"
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: @new_user.username, email: @user.email, password: "password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end


end