ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user, options = {})
    password = options[:password] || 'password'
    if integration_test?
      post login_path, session: { name: user.name,
                                  password: password }
    else
      session[:user_id] = user.id
    end
  end

  private
    def integration_test?
      defined?(post_via_redirect)
    end
end
