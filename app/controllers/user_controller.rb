class UserController < ApplicationController

  def top
    @user = User.find_by(session_id: session[:user_id])
    if @user
       @topics = Topic.where(user_id: @user.user_id).order(created_at: :desc)
    else
      @notice = "未登録"
    end
  end

  def user_create
  end

  def login
  end

  def user_save
    session[:user_id] = (0...8).map{ (65 + rand(26)).chr }.join
    @session_id = session[:user_id]
    @user_id = (0...8).map{ (65 + rand(26)).chr }.join

    if params[:password1] == params[:password2]
      @password = params[:password1]
    else
      flash[:notice] = "エラー：パスワードが一致しません"
      redirect_to("/user") and return
    end

    @user = User.new(
      session_id: @session_id,
      user_id: @user_id,

      have_account: true,
      name: params[:name],
      email: params[:email],
      password: params[@password]
    )

    if @user.save
      flash[:notice] = "ユーザーを登録しました"
      redirect_to("/user")
    else
      #無限ループ処理の脱出
      flash[:notice] = "ユーザー登録に失敗しました"
      redirect_to("/user/error_view")
    end
  end

  def edit
    @user = User.find_by(user_id: params[:id])
  end

  def edit_save
    @user = User.find_by(user_id: params[:id])
    @user.name= params[:name]
    @user.email= params[:email]


    if @topics = Topic.where(user_id: @user.user_id)
        @topics.update_all(user_name: @user.name)
    end

    if @comments = Comment.where(user_id: @user.user_id)
        @comments.update_all(user_name: @user.name)
    end

    if @user.save
      flash[:notice] = "ユーザー情報を保存しました"
      redirect_to("/user")
    else
      flash[:notice] = "保存に失敗しました"
      render("/user/edit")
    end
  end

  def edit_destroy
    @user = User.find_by(user_id: params[:id])
    @topic = Topic.where(user_id: params[:id])
    @topic.destroy_all

    if @user.destroy
      flash[:notice] = "ユーザー情報およびスレッドを削除しました"
      redirect_to("/user")
    else
      flash[:notice] = "削除に失敗しました"
      render("/user/edit")
    end
  end

#セッションを渡して匿名ユーザーをデータベースに登録する
  def give_session
    session[:user_id] = (0...8).map{ (65 + rand(26)).chr }.join
    @session_id = session[:user_id]

    @user_id = (0...8).map{ (65 + rand(26)).chr }.join
    @user = User.new(
      session_id: @session_id,
      user_id: @user_id,
    )
    @user.save

  if @user.session_id
    redirect_to("/topic/create")
  else
    #無限ループ処理の脱出
    redirect_to("/user/create")
  end
  end

  def error_view
      session[:user_id] = nil
      redirect_to("/")
  end

  def logout_question
      @user = User.find_by(session_id: session[:user_id])
      if @user
      @message = "確認：ログアウトします。よろしいですか？"
      else
      @message = "ログインしていません"
      end
  end

  def logout
      session[:user_id] = nil
      flash[:notice] = "ログアウトしました"
      redirect_to("/")
  end
end
