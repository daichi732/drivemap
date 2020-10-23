class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      log_in(user)
      redirect_to places_path, notice: 'ログインしました。'
    else
      flash.now[:notice] = 'メールアドレスまたはパスワードが違います。'
      render 'new'
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  def guest_login
    user = User.find_or_create_by(name: 'ゲストユーザー', email: 'guest@example.com') do |guest_user|
      guest_user.password = SecureRandom.urlsafe_base64
    end
    log_in(user)
    redirect_to places_url, notice: "ゲストユーザーとしてログインしました"
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
