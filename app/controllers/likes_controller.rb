class LikesController < ApplicationController
    before_action :set_like, only: [:delete]

    def create
      @like = Like.new(like_params)

      if @like.save
        render json: @like, status: :created, location: @like
      else
        render json: @like.errors, status: :internal_server_error
      end
    end

    def delete
      @like.destroy
    end

    private
      def set_like
        @like = Like.find_by(id: params[:id])
        unless @like
          return render json: { error: @like.errors.full_messages.join(", ") }, status: :bad_request
        end
      end

      def like_params
        params.require(:like).permit(:user_id, :spot_id)
      end
end
