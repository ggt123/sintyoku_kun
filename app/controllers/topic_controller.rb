class TopicController < ApplicationController
  before_action :check_account,

  def top
      @topics = @topics.order(created_at: :desc)
      @topic
  end

  def create_topic
      unless @named_user || @anonymous_user then
         redirect_to("/topic/create_anonymous_user")
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
        redirect_to("/topic/create_topic")
     else
        flash[:notice] = "問題が発生しました"
        redirect_to("/")
     end
  end

  def save_topic
      if @named_user
        user_id = @named_user.user_id
        user_name = @named_user.name
      elsif @anonymous_user
        user_id = @anonymous_user.user_id
      else
        flash[:notice] = "問題が発生しました"
        redirect_to("/")
      end

      topic_id = (0...8).map{ (65 + rand(26)).chr }.join
      @topic    = Topic.new(
        topic_id:     topic_id,
        title:        params[:title],
        title_topic:  params[:title_topic],
        user_id:      user_id,
        user_name:    user_name
      )

    if @topic.save
       flash[:notice] = "トピックを作成しました"
       redirect_to("/")
    else
       render("/topic/top")
    end
  end

  def show
      @topic    = Topic.find_by(topic_id: params[:id])
      @comments = Comment.where(topic_id: params[:id])
  end

  def edit
      @topic = Topic.find_by(topic_id: params[:id])
  end

  def delete_topic

    topic = Topic.find_by(topic_id: params[:id])

    if @named_user.present?
       if @named_user.user_id == topic.user_id
         if topic.destroy
            flash[:notice] = "トピックを削除しました"
            redirect_to("/")
         end
       end
    elsif @anonymous_user.present?
      if @anonymous_user.user_id == topic.user_id
        if topic.destroy
           redirect_to("/")
           flash[:notice] = "トピックを削除しました"
        end
      end
    else
      flash[:notice] = "問題が発生しました"
      redirect_to("/")
   end
  end

  def save
      @topic = Topic.find_by(topic_id: params[:id])
      @topic.title       = params[:title]
      @topic.title_topic = params[:title_topic]

      if @topic.save
         flash[:notice] = "トピックの編集を保存しました"
         redirect_to("/")
      else
         flash[:notice] = "エラーが発生しました"
         render("/topic/top")
      end
  end

end
