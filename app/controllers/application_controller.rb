class ApplicationController < ActionController::Base
before_action :check_account, :set_topics

  def check_account
     if session[:user_id]
        user = User.find_by(session_id: session[:user_id])
        if user.have_account? == true
           @named_user = user
        elsif user.have_account? == false
           @anonymous_user = user
        end
     end
  end

  def set_topics
    @topics = Topic.all
  end
end
