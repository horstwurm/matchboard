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
  
  def ticketstatus
    if params[:userticket_id]
      @ut = UserTicket.find(params[:userticket_id])
      case params[:status]
        when "zurückgeben"
          @ut.status = "zurückgegeben"
        when "aktivieren"
          @ut.status = "aktiv"
        when "einlösen"
          @ut.status = "eingelöst"
      end
      @ut.save
    end
    redirect_to user_path(:id => @ut.user_id, :topic => "Tickets"), notice: 'Ticketstatus successfully updated '  
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
        @wins << ["<img src=" + u.avatar(:small) + "<br><h3>" + u.created_at.strftime("%d.%m.%Y") + "</h3><p>" + u.geo_address + "</p>"]
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
     @topic = params[:topic].to_sym
   else 
     @topic = :info
   end 

    case @topic
      when :info

        @locs = []
        @wins = []
        @up = @user.user_positions.limit(20).order(created_at: :desc)
        @count = @up.count
        @up.each do |u|
          if u.longitude and u.latitude and u.geo_address
            @locs << [u.user.fullname, u.latitude, u.longitude]
            @wins << ["<h3>" + u.created_at.strftime("%d.%m.%Y") + "</h3><p>" + u.geo_address + "</p>"]
          end
        end
        if @locs.length == 0
            @locs << ["Adresse", @user.latitude, @user.longitude]
            @wins << ["<h3> keine weiteren Positionen gespeichert </h3>" + @user.geo_address ]
          end

        @stats = [["Aktivtät","Anzahl"]]
        @stats << ["Institutionen", @user.companies.count]
        @stats << ["Kalendereinträge", Appointment.where('user_id1=? or user_id2=?',@user.id,@user.id).count]
        @stats << ["Angebote", @user.mobjects.where('mtype=?','angebote').count]
        @stats << ["Ansprechpartner", @user.madvisors.count]
        @stats << ["Kleinanzeigen", @user.mobjects.where('mtype=?','kleinanzeigen').count ]
        @stats << ["Stellenanzeigen", @user.mobjects.where('mtype=?','stellenanzeigen').count ]
        @stats << ["Veranstaltungen", @user.mobjects.where('mtype=?','veranstaltungen').count ]
        @stats << ["Ausschreibungen", @user.mobjects.where('mtype=?','ausschreibungen').count ]
        @stats << ["Ausflugsziele", @user.mobjects.where('mtype=?','ausflugsziele').count ]
        @stats << ["Artikel", @user.mobjects.where('mtype=?','artikel').count ]
        @stats << ["Publikationen", @user.mobjects.where('mtype=?','publikationen').count ]
        @stats << ["Umfragen", @user.mobjects.where('mtype=?','umfragen').count ]
        @stats << ["Projekte/Tasks", @user.mobjects.where('mtype=?','projekte').count ]
        @stats << ["Innovationswettbewerbe", @user.mobjects.where('mtype=?','innovationswettbewerbe').count ]
        @stats << ["Crowdfunding", @user.mobjects.where('mtype=?','crowdfunding').count ]
        @stats << ["Crowdfunding Beiträge", @user.mstats.count ]
        @stats << ["Tickets", @user.user_tickets.count ]
        @stats << ["Bewertungen", @user.mratings.count ]
        @stats << ["Favoriten", @user.favourits.count ]
        @stats << ["Kundenverbindungen", @user.customers.count ]
        @stats << ["ZV Transaktionen", @user.transactions.where('ttype=?', "payment").count]
        @stats << ["Messages", Email.where('m_to=? or m_from=?', @user.id, @user.id).count ]
        @stats << ["Abfragen", @user.searches.count]
    
      when :ressourcenplanung, :zeiterfassung

        if params[:year]
          @c_year = params[:year]
        else
          @c_year = Date.today.year
        end
        if params[:month]
          @c_month = params[:month]
        else
          @c_month = Date.today.month
        end
        if params[:week]
          @c_week = params[:week]
        else
          @c_week = Date.today.cweek
        end
        
        if params[:mode]
          @c_mode = params[:mode]
        else
          @c_mode = "Jahr"
        end
        if params[:scope]
          @c_scope = params[:scope]
        else
          @c_scope = "aufwand"
        end
        
        if params[:dir] == ">"
          if @c_mode == "Woche"
            if @c_week.to_i == 52
              @c_week =  1
              @c_year = @c_year.to_i + 1
            else
              @c_week = @c_week.to_i + 1
            end
          end
          if @c_mode == "Monat"
            if @c_month.to_i == 12
              @c_month =  1
              @c_year = @c_year.to_i + 1
            else
              @c_month = @c_month.to_i + 1
            end
          end
          if @c_mode == "Jahr"
            @c_year = @c_year.to_i + 1
          end
        end
        if params[:dir] == "<"
          if @c_mode == "Woche"
            if @c_week.to_i == 1
              @c_week =  52
              @c_year = @c_year.to_i - 1
            else
              @c_week = @c_week.to_i - 1
            end
          end 
          if @c_mode == "Monat"
            if @c_month.to_i == 1
              @c_month =  12
              @c_year = @c_year.to_i - 1
            else
              @c_month = @c_month.to_i - 1
            end
          end
          if @c_mode == "Jahr"
            @c_year = @c_year.to_i - 1
          end
        end
        
        case @c_mode
          when "Monat"
            @date_start = Date.new(@c_year.to_i,@c_month.to_i,1)
            @date_end = @date_start.end_of_month
          when "Jahr"
            @date_start = Date.new(@c_year.to_i,1,1)
            @date_end = Date.new(@c_year.to_i,12,31)
          when "alles"
        end
        
        myobs = []
        @user.madvisors.each do |a|
          myobs << a.mobject_id 
        end
        @mymobjects = Mobject.where('mtype=? and id IN (?)',"projekte", myobs)

      when :kalendereintraege
        if params[:confirm_id]
          @appoint = Appointment.find(params[:confirm_id])
          if @appoint
            @appoint.confirmed = true
            @appoint.save
          end
        end
        if params[:noconfirm_id]
          @appoint = Appointment.find(params[:noconfirm_id])
          if @appoint
            @appoint.confirmed = false
            @appoint.save
          end
        end
  
        counter = 0 
        @array = ""
        @cals = Appointment.where('user_id1=? and active=?', @user.id, true)
        @anz = @cals.count
        @cals.each do |c|
          time_from = c.time_from.to_s
          if c.time_from.to_s.length == 1
            time_from = "0"+c.time_from.to_s
          end
          time_to = c.time_to.to_s
          if c.time_to.to_s.length == 1
            time_to = "0"+c.time_to.to_s
          end
          @calstart = c.app_date.strftime("%Y-%m-%d")+"T"+time_from+":00"
          @calend = c.app_date.strftime("%Y-%m-%d")+"T"+time_to+":00"
          
          counter = counter + 1
          @array = @array + "{"
          if c.user_id1 == c.user_id2
            @array = @array + "color: '#E0E0E0',"
          else
            if c.confirmed
              @array = @array + "color: '#ACC550',"
            else
              @array = @array + "color: '#61A6A7',"
            end
          end
          @array = @array + "textColor: 'white',"
          user = User.find(c.user_id2)
          case c.channel
            when "Geschäftsstelle"
               icon = '<i class="glyphicon glyphicon-briefcase"></i>'
            when "Treffpunkt"
               icon = '<i class="glyphicon glyphicon-map-marker"></i>'
            when "Wohnort Berater"
               icon = '<i class="glyphicon glyphicon-home"></i>'
            when "Wohnort Kunde"
               icon = '<i class="glyphicon glyphicon-home"></i>'
            when "Telefon"
               icon = '<i class="glyphicon glyphicon-phone-alt"></i>'
            when "VideoChat"
               icon = '<i class="glyphicon glyphicon-facetime-video"></i>'
            else
               icon = '<i class="glyphicon glyphicon-question-sign"></i>'
          end
          @array = @array + "icon: '" + icon + "', "
          if user
            @array = @array + "title: '" + user.name + " " + user.lastname + "', "
          else
            @array = @array + "title: 'unknown', "
          end
          @array = @array + "start: '" + @calstart + "', "
          @array = @array + "end: '" + @calend + "', "
          @array = @array + "url: '" + user_path(:id => c.user_id2, :topic => "Info") +"'" 
          @array = @array + "}"
          if @cals.count >= counter
            @array = @array + ", "
          end
        end

      when :favoriten

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

      when :zugriffsberechtigungen
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

    end
    
    if params[:header] != nil and params[:body] != nil
      UserMailer.send_message(params[:id], params[:header], params[:body]).deliver_now
    end
  
   if params[:trx_status_ok_id]
     @trx = Transaction.find(params[:trx_status_ok_id])
     if @trx
       @trx.status = "freigegeben"
       @trx.save
     end
   end

   if params[:trx_status_ausgefuehrt_id]
     @trx = Transaction.find(params[:trx_status_ausgefuehrt_id])
     if @trx
       @trx.status = "ausgeführt"
       @trx.save
     end
   end

  end

  # GET /users/new
  def new
    # @user = User.new
    # @user.superuser = false
    # if params[:mode] = "signin"
    #   @user.userid = params[:user_id]
    #   @user.active = true
    # end
  end

  # GET /users/1/edit
  def edit
    #@user.status = "changed"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        
        # send eMail
        puts "ATTENTION ATTENTION here we go...."
        UserMailer.signup_confirmation(@user, "newKMU Sign In Confirmation").deliver_now
        
        format.html { redirect_to users_url, notice: 'User was successfully created.' }
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
        redirect_to @user, notice: 'User was successfully updated.'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:costinfo, :rate, :calendar, :time_from, :time_to, :status, :dateofbirth, :email, :active, :anonymous, :webmaster, :userid, :lastname, :name, :address1, :address2, :address3, :geo_address, :longitude, :latitude, :phone1, :phone2, :org, :title, :costrate, :costinfo1, :avatar )
    end
    
end
