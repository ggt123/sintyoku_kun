class CommentController < ApplicationController
  def create
    @topic_id = params[:id]
  end

  def save
    if session[:user_id]
      @user = User.find_by(session_id: session[:user_id])
    else
      session[:user_id] = (0...8).map{ (65 + rand(26)).chr }.join
      @session_id = session[:user_id]

      @user_id = (0...8).map{ (65 + rand(26)).chr }.join
      @user = User.new(
        session_id: @session_id,
        user_id: @user_id,
      )
      @user.save
      @user = User.find_by(session_id: session[:user_id])
    end

    @comment = [
      topic_id: params[:id],
      image_id: params[:image_id],
      topic:    params[:topic],
      user_id:  @user.user_id,
      user_name: @user.name

    ]
  end
end
