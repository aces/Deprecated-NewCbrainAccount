
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper        :all # include all helpers, all the time

  before_filter :verify_admin_token

  def verify_admin_token
    admin_user   = session[:admin]
    unless admin_user
      session.delete(:admin)
      session.delete(:admin_token)
      return
    end
    expect_token = AuthController.send(:admin_token_md5, admin_user)
    return if session[:admin_token] == expect_token
    session.delete(:admin)
    session.delete(:admin_token)
  end

end

