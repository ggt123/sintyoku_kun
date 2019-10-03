class TopicController < ApplicationController

  def top
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

#新しいトピックを保存する　（今回は確認のためにビューファイルへ出力する）
  def save_topic
    @user = User.find_by(session_id: session[:user_id])

    @topic = Topic.new(
      image_id: params[:image],
      title:    params[:title],
      title_topic: params[:title_topic],
      user_id:  @user.user_id
    )
  end

end
