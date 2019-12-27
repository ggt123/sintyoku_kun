class TopicController < ApplicationController

  def top
    @topics = Topic.all.order(created_at: :desc)
    @comments = Comment.all
    @user = User.find_by(session_id: session[:user_id])
  end

  def show
    @topic = Topic.find_by(topic_id: params[:id])
    @user = User.find_by(session_id: session[:user_id])
    @comments = Comment.where(topic_id: params[:id])
    # @comments = comments.order(created_at: :desc)
    @notice = "コメントはまだありません"
  end

#セッションがあるかどうか（過去に使ったことがあるかどうか）を判別する
  def before_create_session_check
    if @user = User.find_by(session_id: session[:user_id])
      redirect_to("/topic/create_topic")
    else redirect_to("/user/give_session")
    end
  end

#セッション確認、または新規作成後　新しいトピック作成のビューページ表示
  def create_topic
  end

#新しいトピックを保存する
  def save_topic
    @user = User.find_by(session_id: session[:user_id])

    @topic = Topic.new(
      image_id: params[:image],
      title:    params[:title],
      title_topic: params[:title_topic],
      user_id:  @user.user_id,
      topic_id: (0...8).map{ (65 + rand(26)).chr }.join,
      user_name: @user.name
    )
    #バリデーション
    if @topic.title.length < 3
      flash[:notice] = "３文字以上入力してください"
      render("/topic/create_topic")
    elsif @topic.save
      flash[:notice] = "スレッドを作成しました"
      redirect_to("/")
    else
      flash[:notice] = "スレッドの作成に失敗しました"
      render("/topic/create_topic")
    end
  end

  def edit
    @topic = Topic.find_by(topic_id: params[:id])
  end

  def save
    @topic = Topic.find_by(topic_id: params[:id])
    @topic.title = params[:title]
    @topic.title_topic = params[:title_topic]

    if @topic.save
      flash[:notice] = "スレッドの変更を保存しました"
      redirect_to("/")
    else
      flash[:notice] = "変更に失敗しました"
      render("/topic/edit")
    end
  end

  def destroy
    @topic = Topic.find_by(topic_id: params[:id])

    if @topic.destroy
      flash[:notice] = "スレッドを削除しました"
      redirect_to("/")
    else
      flash[:notice] = "削除に失敗しました"
      redirect_to("/topic/#{@topic.topic_id}")
    end
  end

end
