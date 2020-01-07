class UserController < ApplicationController
  before_action :check_account

  def top
  end

  def login
  end

  def login_check
      if user = User.find_by(email: params[:email])
        if params[:password] == user.password
           session[:user_id] =  user.session_id
           flash[:notice] = "ログインしました！"
           redirect_to("/")
        else
           flash[:notice] = "ログインに失敗しました"
           redirect_to("/login")
        end
      else
         flash[:notice] = "ログインに失敗しました"
         redirect_to("/login")
      end
  end

  def user_create
    unless @named_user || @anonymous_user then
       redirect_to("/user/create_anonymous_user")
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
        redirect_to("/user_create")
     else
        flash[:notice] = "問題が発生しました"
        redirect_to("/")
     end
  end

  def user_save
    if params[:password1] == params[:password2]
       password = params[:password1]
    else
       flash[:notice] = "エラー：パスワードが一致しません"
       redirect_to("/") and return
    end

      user = User.find_by(session_id: session[:user_id])
      user.session_id   =  user.session_id
      user.user_id      =  user.user_id
      user.have_account =  't',
      user.name         =  params[:name],
      user.email        =  params[:email],
      user.password     =  password

    if user.save(context: :foo)
      flash[:notice] = "ユーザーを登録しました"
      redirect_to("/")
    else
      flash[:notice] = "ユーザー登録に失敗しました"
      redirect_to("/user_create")
    end
  end

  def logout_question
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/")
  end

  def edit
    if @named_user
    else
      redirect_to("/")
    end
  end

  def edit_save
    @named_user.name= params[:name]
    @named_user.email= params[:email]

      if @named_user.password == params[:old_password] && params[:new_password1] == params[:new_password2]
         @named_user.password = params[:new_password1]
         flash[:notice2] = "パスワードを変更しました"

      elsif @named_user.password != params[:old_password]
            flash[:notice2] = "パスワードは変更されていません"

      elsif params[:new_password1] != params[:new_password2]
            flash[:notice2] = "新しいパスワードが不一致のためパスワードは変更されていません"
      end

    if @topics = Topic.where(user_id: @named_user.user_id)
       @topics.update_all(user_name: @named_user.name)
    end

    if @comments = Comment.where(user_id: @named_user.user_id)
       @comments.update_all(user_name: @named_user.name)
    end

    if @named_user.save(context: :foo)
       flash[:notice] = "ユーザー情報を保存しました"
       redirect_to("/user")
    else
       flash[:notice] = "保存に失敗しました"
       render("/user/edit")
    end
  end

  def user_destroy_question
      unless @named_user.user_id == params[:id] then
             redirect_to("/")
      end
  end

  def user_destroy
      if @named_user.user_id == params[:id]
        if @named_user.destroy
           session[:user_id] = nil
           flash[:notice] = "アカウントを削除しました！"
           redirect_to("/")
        end
      else
           flash[:notice] = "アカウント削除に失敗しました"
           redirect_to("/")
      end
  end
end
