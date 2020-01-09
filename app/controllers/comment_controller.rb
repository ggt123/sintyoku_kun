class CommentController < ApplicationController
before_action :check_account


  def create_comment
      if @named_user || @anonymous_user then
         @topic_id = params[:id]
      else
         redirect_to("/comment/create_anonymous_user")
      end
  end

  def create_anonymous_user
       session[:user_id] = (0...8).map{ (65 + rand(26)).chr }.join
       user_id           = (0...8).map{ (65 + rand(26)).chr }.join

       anonymous_user = User.new(
        session_id:   session[:user_id],
        user_id:      user_id
        )

     if anonymous_user.save
        redirect_to("/comment/create_comment")
     else
        flash[:notice] = "問題が発生しました"
        redirect_to("/")
     end
  end

  def save_comment
      if @named_user
        user_id   = @named_user.user_id
        user_name = @named_user.name
      elsif @anonymous_user
        user_id = @anonymous_user.user_id
      else
        flash[:notice] = "問題が発生しました"
        redirect_to("/")
      end

      comment_id = (0...8).map{ (65 + rand(26)).chr }.join
      topic_id = params[:id]

      @comment    = Comment.new(
        topic_id:       topic_id,
        topic:          params[:topic],
        user_id:        user_id,
        user_name:      user_name
      )

    if @comment.save
       flash[:notice] = "コメントを投稿しました"
       redirect_to("/topic/#{topic_id}")
    else
       flash[:notice] = "エラーが発生しました"
       redirect_to("/")
    end
  end

end
