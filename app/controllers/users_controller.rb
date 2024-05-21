class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # users/get_current_user/:uid
  def getCurrentUser
    authInfo = AuthInfo.find_by(id: params[:uid])

    unless authInfo
      return render json: { error: "認証情報が見つかりませんでした" }, status: :bad_request
    end

    currentUser = User.find_by(id: authInfo.user_id)

    unless currentUser
      return render json: { error: "ユーザーが見つかりませんでした" }, status: :bad_request
    end

    render json: currentUser

  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # POST /users
  def create
    # 条件に該当するデータがあればそれを返す。なければ新規作成
    user = User.find_or_create_by(name: params[:name], email: params[:email])
    authInfo = AuthInfo.find_or_create_by(id: params[:uid], provider: params[:provider], user_id: user.id)

    if user and authInfo
      head :ok
    else
      return render json: { error: "ログインに失敗しました" }, status: :internal_server_error
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :internal_server_error
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      unless user
        return render json: { error: "ユーザーが見つかりませんでした" }, status: :bad_request
      end
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :name)
    end
end
