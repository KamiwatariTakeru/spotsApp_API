class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  def getCurrentUser
    authInfo = AuthInfo.find_by(id: params[:uid])
    currentUser = User.find(authInfo.user_id)
    render json: currentUser
  end

  # POST /users
  def create
    # 条件に該当するデータがあればそれを返す。なければ新規作成
    user = User.find_or_create_by(name: params[:name], email: params[:email])
    authInfo = AuthInfo.find_or_create_by(id: params[:uid], provider: params[:provider], user_id: user.id)

    if user and authInfo
      head :ok
    else
      render json: { error: "ログインに失敗しました" }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
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
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :name)
    end
end
