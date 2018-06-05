class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def webmaster
    if @user.webmaster == true
      @user.webmaster = false
    else
      @user.webmaster = true
    end
    @user.save
    redirect_to @user, notice: 'Webmaster '  
  end
  
  def index
    @controller_name = controller_name
    if params[:page] != nil
      session[:page] = params[:page]
    end
    @filter = params[:filter_id]
    @users = User.search(params[:filter_id],params[:search]).order(created_at: :desc).page(params[:page]).per_page(10)
    @usanz = @users.count

    @locs = []
    @wins = []
    @users.each do |u|
      if u.longitude and u.latitude and u.geo_address
        @locs << [u.fullname, u.latitude, u.longitude]
        @wins << ["<img src=" + u.avatar(:small) + "<br><h3>" + u.name + " " + u.lastname + "</h3><p>" + u.geo_address + "</p>"]
      end
    end
    if @locs.length == 0
        @locs << ["Adresse", 100, 100]
        @wins << ["<h3> keine Geodaten vorhanden </h3>" ]
    end
    
  end
  
  # GET /users/1
  # GET /users/1.json
  def show

   if params[:topic]
     @topic = params[:topic]
   else 
     @topic = "personen_info"
   end 

    case @topic
      when "personen_info"

        @mtypes = Mobject.select("mtype").distinct
        @stats = [["Aktivtäten","Anzahl"]]
        @stats << ["Institutionen", @user.companies.count]
        @stats << ["Favoriten", @user.favourits.count ]
        @stats << ["Abfragen", @user.searches.count]
        @mtypes.each do |t|
          @text = t.mtype
          @anz = @user.mobjects.where('mtype=?',t.mtype).count
          @stats << [@text, @anz]
        end

      when "personen_zugriffsberechtigungen"
        if params[:credential_id]
          @c = Credential.find(params[:credential_id])
          if @c
            #@c.edit
            if @c.access
              @c.access=false
            else
              @c.access=true
            end
            @c.save
          end
        end

      when "personen_favoriten"
        @locs = []
        @wins = []
        @favourits = Favourit.where('user_id=? and object_name=?', @user.id, "user") 
        @favourits.each do |f|
          u = UserPosition.where('user_id=?',f.object_id).last
          if u and u.longitude and u.latitude and u.geo_address
            @locs << [u.user.fullname, u.latitude, u.longitude]
            @wins << ["<img src=" + u.user.avatar(:medium) + "<h3>" + u.user.fullname + "</h3><p>" + u.geo_address + "</p>"]
          end
        end
        if @locs.length == 0
            @locs << ["Adresse", @user.latitude, @user.longitude]
            @wins << ["<h3> keine weiteren Positionen gespeichert </h3>" + @user.geo_address ]
        end

    end
    
    if params[:header] != nil and params[:body] != nil
      UserMailer.send_message(params[:id], params[:header], params[:body]).deliver_now
    end
  
  end

  # GET /users/new
  def new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        
        # send eMail
        #puts "ATTENTION ATTENTION here we go...."
        UserMailer.welcome_email(@user).deliver_now
        
        format.html { redirect_to users_url, notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
        redirect_to @user, notice: (I18n.t :act_update)
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    redirect_to users_path, notice: (I18n.t :act_delete)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:classificacion, :status, :dateofbirth, :email, :active, :anonymous, :webmaster, :userid, :lastname, :name, :address1, :address2, :address3, :geo_address, :longitude, :latitude, :phone1, :phone2, :avatar )
    end
    
end
