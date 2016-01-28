require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username:"John", email:"john@example.com", password: "password", admin:true)
  end

  test 'valid article created' do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template "articles/new"
    assert_difference 'Article.count', 1 do
      post_via_redirect articles_path, article: {
        title: "Title",
        description: "Description",
        user_id: @user.id
        }
    end
    assert_template 'articles/show'
    assert_match @user.username, response.body
    assert_match "Title", response.body
  end

  test 'rejects without title' do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template "articles/new"
    assert_no_difference 'Article.count' do
      post_via_redirect articles_path, article: {
        description: "Description",
        user_id: @user.id
        }
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'rejects without description' do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template "articles/new"
    assert_no_difference 'Article.count' do
      post_via_redirect articles_path, article: {
        title: "Title",
        user_id: @user.id
        }
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'rejects long description' do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template "articles/new"
    assert_no_difference 'Article.count' do
      post_via_redirect articles_path, article: {
        title: "Title",
        description: "a"*10001,
        user_id: @user.id
        }
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'rejects short title' do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template "articles/new"
    assert_no_difference 'Article.count' do
      post_via_redirect articles_path, article: {
        title: "aa",
        description: "Description",
        user_id: @user.id
        }
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'rejects long title' do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template "articles/new"
    assert_no_difference 'Article.count' do
      post_via_redirect articles_path, article: {
        title: "a"*351,
        description: "Description",
        user_id: @user.id
        }
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'rejects short description' do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template "articles/new"
    assert_no_difference 'Article.count' do
      post_via_redirect articles_path, article: {
        title: "Title",
        description: "aa",
        user_id: @user.id
        }
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end