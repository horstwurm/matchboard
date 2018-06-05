class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
    @controller_name = controller_name
    
    if params[:page]
      session[:page] = params[:page]
    end
    
    @games = Game.all.order(created_at: :desc).page(params[:page]).per_page(10)
    @gameanz = @games.count
   counter = 0 
   @locs = []
   @wins = []
   @games.each do |c|
      if c.mobject.longitude and c.mobject.latitude and c.mobject.geo_address
        @locs << [c.mobject.name, c.mobject.latitude, c.mobject.longitude.to_s]
        if c.mobject.mdetails.first and c.mobject.mdetails.first.avatar
          pic = "<img src="+ c.mobject.mdetails.first.avatar_file_name + ">"
        else
          #path=File.join(Rails.root, "/app/assets/images/")
          pic = "<img src='plaetze.png'>"
          pic = image_tag("plaetze.png")
        end
        #@wins << ["<img src=" + avatar(:small) + "<br><h3>" + c.mobject.name + "</h3><p>" + c.mobject.geo_address + "</p>"]
        @wins << [pic+ "<br><h3>" + c.mobject.name + "</h3><p>" + c.mobject.geo_address + "</p>"]
      end
    end

  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
    if params[:user_id]
      @game.user_id = current_user.id
      @game.mobject_id = 1
      @game.player1 = User.find(current_user.id).email
      @game.player2 = User.find(params[:user_id]).email
      @game.mcategory_id = "9"
      @game.modus = "TieBreak"
    end
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to home_index3_path, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:mobject_id, :user_id, :modus, :mcategory_id, :player1, :player2, :player3, :player4)
    end
end
