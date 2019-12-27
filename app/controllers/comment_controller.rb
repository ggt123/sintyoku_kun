class CommentController < ApplicationController
  def create
    @topic_id = params[:id]
  end

  def save
    if session[:user_id] = true
      @user = User.find_by(session_id: session[:user_id])
    end

    if @user
    @user = User.find_by(session_id: session[:user_id])
    @comment = Comment.new(
      topic_id: params[:id],
      image_id: params[:image_id],
      topic:    params[:topic],
      user_id:  @user.user_id,
      user_name: @user.name
    )
    if @comment.topic.length < 3
    flash[:notice] = '３文字以上入力してください'
    redirect_to("/topic/#{@comment.topic_id}")

  elsif @comment.save
    flash[:notice] = 'コメントを投稿しました'
    redirect_to("/topic/#{@comment.topic_id}")
  else
    flash[:notice] = "問題が発生しました"
    render("/comment/create/#{@comment.topic_id}")
  end

else
  session[:user_id] = (0...8).map{ (65 + rand(26)).chr }.join
  @session_id = session[:user_id]
  @user_id = (0...8).map{ (65 + rand(26)).chr }.join

  @user = User.new(
    session_id: @session_id,
    user_id: @user_id
  )
  @user.save
  @comment = Comment.new(
    topic_id: params[:id],
    image_id: params[:image_id],
    topic:    params[:topic],
    user_id:  @user.user_id,
    user_name: @user.name
  )
  if @comment.topic.length < 3
  flash[:notice] = '３文字以上入力してください'
  redirect_to("/topic/#{@comment.topic_id}")

elsif @comment.save
  flash[:notice] = 'コメントを投稿しました'
  redirect_to("/topic/#{@comment.topic_id}")
else
  flash[:notice] = "問題が発生しました"
  render("/comment/create/#{@comment.topic_id}")
end
end
end
end
