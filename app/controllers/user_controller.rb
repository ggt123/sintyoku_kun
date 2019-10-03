class UserController < ApplicationController

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
    redirect_to("/user/error_view")
  end
end

def error_view
    session[:user_id] = nil
    redirect_to("/")
end

end
