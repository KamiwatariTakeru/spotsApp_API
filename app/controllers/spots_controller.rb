class SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :update, :destroy, :evaluate]

  # GET /spots
  def index
    @spots = Spot.all
    # とりあえず空の配列を返して後で修正
    render json: [], status: :ok
    if @spots.nil? || @spots.empty?
      puts "bbb"
      render json: [], status: :ok
    else
      puts "ccc"
      render json: @spots, status: :ok
    end
  end

  # GET /spots/1
  def show
    render json: @spot
  end

  # POST /spots
  def create
    puts params[:name]
    puts params[:address]
    puts params[:stars_sum]
    puts params[:stars_avg]

    begin
      # 入力された住所から緯度経度を取得してテーブルに登録
      @spot = Spot.new(spot_params)

      puts "1"

      coordinate = geocode_address(params[:address])

      puts "2"

      if coordinate.nil?
        render json: { error: "Address geocoding failed" }, status: :unprocessable_entity
      end

      @spot.latitude = coordinate[:lat]
      @spot.longitude = coordinate[:lng]

      puts "3"

      if @spot.save
        render json: @spot, status: :created, location: @spot
      else
        render json: @spot.errors, status: :internal_server_error
      end
    rescue => e
      puts "rescue"
      puts e
    end
  end

  # PATCH/PUT /spots/1
  def update
    if @spot.update(spot_params)
      render json: @spot
    else
      render json: @spot.errors, status: :internal_server_error
    end
  end

  # DELETE /spots/1
  def destroy
    @spot.destroy
  end

  def search
    # パラメーターから検索ワードを取得
    search_word = params[:word]

    # name または address が検索ワードに合致するレコードを取得
    @searched_spots = Spot.where("name LIKE ? OR address LIKE ?", "%#{search_word}%", "%#{search_word}%")
    render json: @searched_spots

  end

  # 入力された住所から座標を取得
  def getCoordinate
    spot = Spot.find(params[:id])
    unless spot
      return render json: { error: "投稿が見つかりません" }, status: :bad_request
    end

    render json: { lat: spot.latitude, lng: spot.longitude }
  end

  def evaluate
    evaluation = Evaluation.find(params[:evaluation_id])
    unless evaluation
      return render json: { error: "評価レコードが存在しません" }, status: :bad_request
    end

    # 新しく評価した星の数 - 前回評価した星の数をEvaluationレコードのstars_sumに加算する
    starsAmountThisTime = params[:stars_amount].to_i

    addStarsAmount = starsAmountThisTime - evaluation.starsAmount.to_i
    @spot.stars_sum += addStarsAmount

    evaluation.starsAmount = starsAmountThisTime

    if not evaluation.save
      render json: evaluation.errors, status: :internal_server_error
    end

    evaluationsCount = Evaluation.where(spot_id: params[:id]).count

    # Infinityを防ぐため、stars_sumが0であるかどうかを確認し、ゼロでない場合のみ平均値を計算する
    if @spot.stars_sum > 0
      @spot.stars_avg = @spot.stars_sum / evaluationsCount.to_f
    else
      @spot.stars_avg = 0
    end

    if @spot.save
      render json: @spot
    else
      render json: @spot.errors, status: :internal_server_error
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spot
      @spot = Spot.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def spot_params
      params.require(:spot).permit(:name, :address, :stars_sum, :stars_avg)
    end

  # 住所から緯度経度を取得
  # app/controllers/spots_controller.rb
  def geocode_address(address)
    api_key = 'AIzaSyASIHKfIBO5DVbR-HZTqPHNDrCZUbRVJDw'
    base_url = 'https://maps.googleapis.com/maps/api/geocode/json'

    # RestClient を適切にロード
    require 'rest-client'

    response = RestClient.get(base_url, params: { address: address, key: api_key })
    result = JSON.parse(response.body)

    if result['status'] == 'OK' && result['results'].present?
      location = result['results'][0]['geometry']['location']
      { lat: location['lat'], lng: location['lng'] }
    else
      { error: 'Geocoding failed' }
    end
  end
end
