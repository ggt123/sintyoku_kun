class UserController < ApplicationController

  def top
    @user = User.find_by(session_id: session[:user_id])
    if @user
       @topics = Topic.where(user_id: @user.user_id)
    else
      @notice = "未登録"
    end
  end

  def user_create
  end

  def user_save
    session[:user_id] = (0...8).map{ (65 + rand(26)).chr }.join
    @session_id = session[:user_id]

    @user_id = (0...8).map{ (65 + rand(26)).chr }.join
    @user = User.new(
      session_id: @session_id,
      user_id: @user_id,

      have_account: true,
      name: params[:name],
      email: params[:email],
      password: params[:password]
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


    @topic = Topic.find_by(user_id: @user.user_id)
    @topic.user_name = params[:name]

    if @user.save && @topic.save
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

end
