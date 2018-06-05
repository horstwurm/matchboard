class HomeController < ApplicationController

def playersearch
  @users = User.all
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

def index
    @users = User.select("date(created_at) as datum, count(id) as summe").group("date(created_at)")
    @anz_pk = [['Datum','Anzahl']]
    @users.each do |i|
      @anz_pk << [i.datum.to_s, i.summe]
    end

    @companies = Company.select("date(created_at) as datum, count(id) as summe").group("date(created_at)")
    @anz_fk = [['Datum','Anzahl']]
    @companies.each do |i|
      @anz_fk << [i.datum.to_s,  i.summe]
    end

    @objects = Mobject.select("date(created_at) as datum, count(id) as summe").group("date(created_at)")
    @anz_obj = [['Datum','Anzahl']]
    @objects.each do |i|
      @anz_obj << [i.datum.to_s, i.summe]
    end

  if user_signed_in?
    #redirect_to current_user
  end
end

def index1
  if user_signed_in?
    case params[:status] 
      when "einlösen"
        if params[:userticket_id]
          @ticket = UserTicket.find(params[:userticket_id])
          @ticket.status = "eingelöst"
          @ticket.save
        end
      when "reaktivieren"
        if params[:userticket_id]
          @ticket = UserTicket.find(params[:userticket_id])
          @ticket.status = "aktiv"
          @ticket.save
        end
    end
    if params[:me]
      @ticket = UserTicket.where('id=?',params[:me]).first
      if @ticket
        if @ticket.owner_type == "Msponsor"
          if @ticket.ticket.msponsor.company.user.id == current_user.id
            @auth_status = "autorisiert"
          else
            @auth_status = "nicht autorisiert"
            @auth_reason = "nur " + @ticket.ticket.msponsor.company.user.name + " " + @ticket.ticket.msponsor.company.user.lastname + "!"
          end
        end
        if @ticket.owner_type == "Mobject"
          if @ticket.ticket.owner.company.user.id == current_user.id
            @auth_status = "autorisiert"
          else
            @auth_status = "nicht autorisiert"
            @auth_reason = "nur " + @ticket.ticket.owner.company.user.name + " " + @ticket.ticket.owner.company.user.lastname + "!"
          end
        end
        if @ticket.status == "aktiv"
          @ticket_status = "Ticket gültig"
        else
          @ticket_status = "Ticket ungültig"
          @status_reason = "Ticketstatus muss 'aktiv' sein!, ist aber " + @ticket.status 
        end
      end
    end
  else
    redirect_to home_index7_path, notice: "Kein Benutzer angemeldet!"
  end
end

def index2
    @users = User.all.order(last_sign_in_at: :desc).page(params[:page]).per_page(20)
    @usanz = @users.count
end

def index3
  session[:page] = nil
end

def index4
    @users = User.all.last
    @hash = Gmaps4rails.build_markers(@users) do |user, marker|
      if user.latitude != nil and user.longitude != nil
        marker.lat user.latitude
        marker.lng user.longitude
        marker.infowindow "<a href=/users/" + user.id.to_s + ">" + user.name + "</a>"
        if user.avatar 
          marker.picture :url => url_for(user.avatar(:small)), :width => 50, :height => 50
        else
          marker.picture :url => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|", :width => 50, :height => 50
        end
      end
     end
     @hash.push({lat: request.location.latitude, lng: request.location.longitude, infowindow: "img src="+url_for(User.find(1).avatar(:small)) })

@user = current_user
@lat = request.location.latitude
@lng = request.location.longitude 
@text = @lat.to_s + "/" + @lng.to_s
end

def index5
  @test = DonationStat.select("date(created_at) as datum, count(amount) as summe").group("date(created_at)")

  @array = []
  @cat = Category.all
  @cat.each do |c|
    anz = Company.where('category_id=?', c.id).count
    if anz > 0
      hash = Hash.new
      hash = {"label" => c.name, "value" => anz}
      @array << hash
    end
  end
  
  @array.each do |a|
    puts a.to_s
  end
  
end

def index6
  @searches = Search.where('user_id=?', current_user.id).order(:mtype)
end

def index7
 if params[home_index7_path]
   @test = params[home_index7_path][:domain]
 else
   @test = "Veranstaltungen"
 end 
 counter = 0 
 @array = ""
 case @test
  when "Geburtstage Favoriten"
     @users = current_user.favourits
     @anz = @users.count
     @users.each do |u|
          if u.object_name == "User" 
            @user = User.find(u.object_id)
            if @user and @user.dateofbirth

              @caldate = Date.today.year.to_s + "-" + @user.dateofbirth.strftime("%m-%d")
              
              counter = counter + 1
              @array = @array + "{"
              @array = @array + "color : '#ACC550',"
              @array = @array + "textColor : 'white',"
              @array = @array + "title : '" + @user.name + " " + @user.lastname + "', "
              @array = @array + "start : '" + @caldate + "', "
              @array = @array + "url : '" + user_path(:id => @user.id, :topic => "personen_nfo") +"'" 
              @array = @array + "}"
              if current_user.favourits.count >= counter
                @array = @array + ", "
              end  
            end
          end
      end
      
  when "Veranstaltungen", "Crowdfunding", "Aktionen", "Ausschreibungen", "Stellenanzeigen"
    if @test == "Aktionen"
      @mobjects = Mobject.where('mtype=? and msubtype=?', "Angebote", "Aktion")
    else
      @mobjects = Mobject.where('mtype=?', @test)
    end
    @anz = @mobjects.count
    @mobjects.each do |u|
          if u.date_from
            counter = counter + 1
            @array = @array + "{"
            @array = @array + "color : '#ACC550',"
            @array = @array + "textColor : 'white',"
            @array = @array + "title : '" + u.name + "', "
            @array = @array + "start : '" + u.date_from.to_s + "', "
            if u.date_to
              @array = @array + "end : '" + u.date_to.to_s + "', "
            end
            @array = @array + "url : '" + mobject_path(:id => u.id, :topic => "objekte_info") +"'" 
            @array = @array + "}"
            if @mobjects.count >= counter
              @array = @array + ", "
            end  
          end
      end
  end
end
  
def index8
  @mtype = params[:mtype]
  @user_id = params[:user_id]
  @company_id = params[:company_id]
end

def index9
  @categories = Mcategory.select("ctype").distinct
end

def index10
  if user_signed_in?
    
    if params[:day]
      @n = params[:day].to_i
    else
      @n=1
    end
    
    # follow Tickets
    @usertickets = UserTicket.where('user_id=? and (status=? or status=?) and created_at>=?', current_user.id, "übergeben", "persönlich", @n.day.ago).order(created_at: :desc)

    # follow Favoriten
    @favourits = current_user.favourits.where('created_at>=?',@n.day.ago).order(created_at: :desc)

    # follow Termine
    @appointments = Appointment.where('user_id1=? and created_at>=?', current_user.id, @n.day.ago ).order(created_at: :desc)
    
    # follow Transaktionen
    @transactions = current_user.transactions.where('created_at>=?', @n.day.ago ).order(created_at: :desc)
    
    @customers = current_user.customers.order(created_at: :desc)

    # follow eMails
    @emails  = Email.where('m_to=? and created_at>=?', current_user.id, @n.day.ago ).order(created_at: :desc)
    
    # follow Objects from Favouriten
    @mobjects = current_user.mobjects.order(created_at: :desc)

    # follow Searches
    @searches = current_user.searches.order(created_at: :desc)
    
  end    
end

def index11
  if params[:kam_id]
    @campaign = Mobject.find(params[:kam_id])
    @company = @campaign.owner
    @signages = @campaign.mdetails
    @location = nil
  end
  if params[:loc_id]
    @location = Mobject.find(params[:loc_id])
    @company = @location.owner
    @campaigns = SignageCal.where('mstandort=?',params[:loc_id])
    @signages = nil
  end
  
end

def index12
end

def index13
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render :json => @users }
    end
end

def index14
  random = Random.new(Time.new.to_i)
  ra1 = rand(100)+1
  
  @anz_obj = []
  for i in 0..ra1
    temp = Hash.new
    temp = {"Nummer"+ i.to_s => i}
    @anz_obj << temp
  end
end

def dashboard_data
    respond_to do |format|
      format.json 
        msg = [{:kategorie => "User", :anzahl => User.all.count},{:kategorie => "UserOnline", :anzahl => User.where("updated_at > ?", 10.minutes.ago).count},{:kategorie => "Publikationen", :anzahl => Mobject.where('mtype=?',"Publikationen").count},{:kategorie => "Artikel", :anzahl => Mobject.where('mtype=?',"Artikel").count},{:kategorie => "Veranstaltungen", :anzahl => Mobject.where('mtype=?',"Veranstaltungen").count}]
        render :json => msg.to_json
    end
end

def arduino
    respond_to do |format|
      format.json 
        msg = []
        msg << {:user => User.where("updated_at > ?", 10.minutes.ago).count}
        msg << {:reg => User.count}
        msg << {:projekte => Mobject.where("mtype=?", "projekte").count}
        msg << {:aufwand => Timetrack.count}
        msg << {:kapa => Planning.count}
        msg << {:wettbewerbe => Mobject.where('mtype=?',"innovationswettbewerbe").count}
        msg << {:ideen => Idea.count}
        render :json => msg.to_json
    end
end

def dashboard2_data
    respond_to do |format|
      format.json 
        msg = []
        msg << {:kategorie => "User", :anzahl => User.all.count}
        msg << {:kategorie => "UserOnline", :anzahl => User.where("updated_at > ?", 10.minutes.ago).count}
        @cats = Mobject.select("mtype").distinct
        @cats.each do |c|
          count = Mobject.where('mtype=?', c.mtype).count
          if count > 0
            msg << {:kategorie => c.mtype, :anzahl => count}
          end
        end
        render :json => msg.to_json
    end
end

def dashboard_projectdata

  @mobject = Mobject.find(params[:pid])
  @prolist = [@mobject.id]
  @mobject.wo_iterate(@mobject.id, true, @prolist)
  @projects = Mobject.where("mtype=? and id in (?)", "projekte", @prolist)
  msg = []
  @projects.each do |p|
    @kosten = p.timetracks.where('costortime=?',"kosten").sum(:amount)
    @aufwand = p.timetracks.where('costortime=?',"aufwand").sum(:amount)
    if @kosten
      msg << {:id => p.id, :kategorie => "kosten", :summe => @kosten}
    end
    if @aufwand
      msg << {:id => p.id, :kategorie => "aufwand", :summe => @aufwand}
    end 
  end
  respond_to do |format|
    format.json
      render :json => msg.to_json
  end
end

def dashboard
end

def index15
  @question = Question.find(params[:question_id])
  
  if @question.mcategory.name == "text" or @question.mcategory.name == "numerisch" 
    if @question.answers.count == 0
      @a = Answer.new
      @a.question_id = @question.id
      @a.name = "Bitte angeben"
      @a.save
    end  
  end
  
  if params[:user_answer_id]
    @ua = UserAnswer.find(params[:user_answer_id])
    @a = @ua.answer
    
    if @question.mcategory.name == "single"
      @question.answers.each do |qa|
        @uai = UserAnswer.where('user_id=? and answer_id=?', current_user.id, qa.id).first
        if @uai and @uai.checker
          @uai.checker = false
          @uai.save
        end
      end
    end
    if @ua
      if @question.mcategory.name == "multiple"
        if @ua.checker
          @ua.checker = false
        else
          @ua.checker = true
        end
      else
        @ua.checker =true
      end
      @ua.save
    end
  end
end


def index16
  @question = Question.find(params[:question_id])
end

def index17
  if params[:mailgunflag]
    $usemailgun = true
  else
    $usemailgun = false
  end
  #UserMailer.welcome_email(User.last).deliver_now
  redirect_to home_index3_path
end

def index18
  if params[:standort]
    @campaigns = SignageCal.where("mstandort=? and date_from<=? and date_to>=?",params[:standort], Date.today, Date.today)
    if @campaigns
      @mob = Mobject.find(params[:standort])
      @owner = @mob.owner
      @standort = @mob
      @campanz = @campaigns.count
      @camp = "("
      @campaigns.each do |c|
        @camp = @camp + Mobject.find(c.mkampagne).name + " "
      end
      @camp = @camp + ")"
    else
      @campanz = 0
    end
  end
  if params[:kampagne]
    @campaigns = SignageCal.where("mkampagne=?",params[:kampagne])
    @mob = Mobject.find(params[:kampagne])
    @kampagne = @mob
    @owner = @mob.owner
  end
end

def index20
  if params[:company_id] and params[:mtype]
    if !user_signed_in?
      redirect_to company_path(:id => params[:company_id], :topic => "objekte_sponsorantraege"), notice: (I18n.t :firstsignin)
    else
      @company_id = params[:company_id]
      @mtype = params[:mtype]
      @companies = current_user.companies
    end
  end
end

def import
    path=File.join(Rails.root, "/app/assets/images/mig2017.xlsx")
    workbook = Creek::Book.new path
    @worksheets = workbook.sheets
end

def Umfragen_data

    @question = Question.find(params[:question_id])
  
    @array = []
    @question.answers.each do |qa|
      
      anz = qa.user_answers.where('checker=?',true).count
      
      hash = Hash.new
      hash = {:kategorie => qa.name, :anzahl => anz.to_s}
      @array << hash
      
    end

    #msg = [{:kategorie => "User", :anzahl => User.all.count},{:kategorie => "UserOnline", :anzahl => User.where("updated_at > ?", 10.minutes.ago).count},{:kategorie => "Publikationen", :anzahl => Mobject.where('mtype=?',"Publikationen").count},{:kategorie => "Artikel", :anzahl => Mobject.where('mtype=?',"Artikel").count},{:kategorie => "Veranstaltungen", :anzahl => Mobject.where('mtype=?',"Veranstaltungen").count}]

    respond_to do |format|
      format.json 
        render :json => @array.to_json
    end

end

def dashboard_project
end

def readLastValue
  msg = []
  if params[:sensor]
    @sensor = Mobject.find(params[:sensor])
    @iot = @sensor.sensors.last
    if @iot
      if @iot.value
          msg << {:datum => @iot.created_at.strftime("%H:%m"), :wert => @iot.value}
      end
      if @iot.svalue
          msg << {:datum => @iot.created_at.strftime("%H:%m"), :wert => @iot.svalue}
      end
      if @iot.bvalue
          msg << {:datum => @iot.created_at.strftime("%H:%m"), :wert => @iot.bvalue}
      end
    else
      msg << {:datum => Date.today.strftime("%H:%m"), :wert => 0}
    end
  else
      msg << {:datum => Date.today.strftime("%H:%m"), :wert => 0}
  end
  respond_to do |format|
    format.json 
      render :json => msg.to_json
    format.html
  end
end

def readsensordata
  if params[:sensor]
    @sensor = Mobject.find(params[:sensor])
    @iots = @sensor.sensors.order(:created_at)
  else
    @iots = Sensor.all.order(:created_at)
  end
  respond_to do |format|
    format.json 
      msg = []
      #msg << {:datum => "Datum", :wert => "Wert"}
      @iots.each do |i|
        msg << {:datum => i.created_at.strftime("%H:%m"), :wert => i.value}
      end
      render :json => msg.to_json
  end
end

def writesensordata
  if params[:sensor] and params[:value]
    @sensor = Sensor.new
    @sensor.mobject_id = params[:sensor]
    @sensor.value = params[:value]
    @sensor.save
  end
  @sensors = Mobject.find(params[:sensor]).sensors
  msg = []
  if @sensors and @sensors.count > 0 
    msg << {:type => "Anzahl", :anzahl => @sensors.count}
  else
    msg << {:type => "Anzahl", :anzahl => 0}
  end
  respond_to do |format|
    format.json 
      render :json => msg.to_json
  end
end

def readusernotes
  if params[:user]
    @user = User.find(params[:user])
    @notes = @user.notes.order(:message)
  end
  respond_to do |format|
    format.json 
      msg = []
      @notes.each do |i|
          msg << {:message => @user.name+"_"+@user.lastname+" "+i.message}
      end
      render :json => msg.to_json
  end
end

def writeusernotes
  if params[:user] and params[:message]
    @ns = User.find(params[:user]).notes.where('message=?', params[:message])
    if !@ns or @ns.count == 0
      @note = Note.new
      @note.user_id = params[:user]
      @note.message = params[:message]
      @note.datum=Date.today
      @note.uhrzeit=8000
      @note.save
    end
  end
  respond_to do |format|
    format.json 
      msg = []
      msg << {:status => "ok"}
      msg << {:anzahl => User.find(params[:user]).notes.count }
      render :json => msg.to_json
  end
end
def test
end

def readuser
  if params[:nname] and params[:vname]
    @ns = User.where('lastname=? and name=?',params[:nname], params[:vname]).first
  else 
    if params[:nname]
      @ns = User.where('lastname=?',params[:nname]).first
    end
  end
  respond_to do |format|
    format.json 
      msg = []
      if @ns
        msg << {:name => @ns.name + " " + @ns.lastname}
        msg << {:nummer => @ns.id }
      else
        msg << {:name => "unknown"}
        msg << {:nummer => -1 }
      end
      render :json => msg.to_json
  end
end

def writeuserpos
  if params[:user] and params[:longitude] and params[:latitude]
      @pos = UserPosition.new
      @pos.user_id = params[:user]
      @pos.longitude = params[:longitude]
      @pos.latitude = params[:latitude]
      @pos.save
  end
  respond_to do |format|
    format.json 
      msg = []
      msg << {:status => "ok"}
      msg << {:anzahl => User.find(params[:user]).user_positions.count }
      render :json => msg.to_json
  end
end

def test
         @locs = []
         @wins = []
         @user=User.find(1);
         @user.user_positions.each do |u|
    
            if u.longitude and u.latitude
           
              @locs << [u.user.fullname, u.latitude, u.longitude]
              if u.user.avatar_file_name 
                img = url_for(u.user.avatar(:small))
              else
                img = File.join(Rails.root, "/app/assets/images/no_pic.jpg")
              end
              #@wins << ["'<img src=" + img + " <br><h3>" + u.fullname + "</h3><p>" + u.geo_address + "</p>'"]
              @wins << ["'<img src=" + img + " <br><h3>" + u.user.fullname + "</h3></p>'"]
    
            end
          end

end

def alexa
  case params[:intent]
    when "Projektinfo"
      @p = Mobject.where('LOWER(name) LIKE ?',"%#{params[:slot].downcase}%").first
      if @p
        response = "Projekt gefunden"
        response = {:slot => params[:slot], :projekt => "gefunden", :name => @p.name, :owner => @p.owner.name, :stunden => @p.timetracks.where('costortime=?',"aufwand").sum(:amount), :kosten => @p.timetracks.where('costortime=?',"kosten").sum(:amount)}
      else
        response = {:projekt => "Projekt nicht gefunden"}
      end
    else
      response = {:message => "wrong intent"}
  end
  respond_to do |format|
    format.json 
      #msg = {:message => response}
      render :json => response.to_json
  end
end

def writeiot
  if params[:owner_id] and params[:owner_type] and params[:frame] and params[:name] and params[:value]
      @iot = Iot.new
      @iot.owner_id = params[:owner_id]
      @iot.owner_type = params[:owner_type]
      @iot.frame = params[:frame]
      @iot.name = params[:name]
      @iot.value = params[:value]
      @iot.save
  end
  respond_to do |format|
    format.json 
      msg = {:anzahl => Iot.where('owner_id=? and owner_type=? and frame=? and name=?', params[:owner_id], params[:owner_type], params[:frame], params[:name]).count}
      render :json => msg.to_json
  end
end

def readiot
  if params[:owner_id] and params[:owner_type] and params[:frame] and params[:name]
      @iot = Iot.where('owner_id=? and owner_type=? and frame=? and name=?', params[:owner_id], params[:owner_type], params[:frame], params[:name]).last
      if @iot 
        msg = {value: @iot.value}
      else
        msg = {value: "undefined"}
      end
    else
        msg = {value: "invalid request"}
  end
  respond_to do |format|
    format.json 
      render :json => msg.to_json
  end
end

def writeimage
  path=File.join(Rails.root, "/app/assets/images/")
  if params[:mobject_id] and params[:image_text]
      @mobject = Mobject.find(params[:mobject_id])
      encoded_string = params[:image_text]
      File.open(path+"base64test.jpg", "wb") do |file|
        file.write(Base64.decode64(encoded_string))
      end
      @mdetails = Mdetail.new
      @mdetails.mobject_id = params[:mobject_id]
      @mdetails.name = "Test"
      @mdetails.avatar = File.open(path+'base64test.jpg', 'rb')
      @mdetails.save
  end
  respond_to do |format|
    format.json 
      msg = {:name => @mobject.name, :anzahl => @mobject.mdetails.count}
      render :json => msg.to_json
  end
end

def temptest
  if params[:game_id]
    @game = Game.find(params[:game_id])
    @result = @game.results.last
  end
end

def tenniscounter
  home = "undefined"
  guest = "undefined"
  message = "undefined"

  if params[:game_id] and params[:action_code]
    @game = Game.find(params[:game_id])
    #find last result
    @mobject = Mobject.find(@game.mobject_id)
    @result = @game.results.last
    if !@result
      @result = Result.new
      message = "init game"
      @result.game_id = params[:game_id]
      @result.set1H = 0
      @result.set1G = 0
      @result.set2H = 0
      @result.set2G = 0
      @result.set3H = 0
      @result.set3G = 0
      @result.gameH = "00"
      @result.gameG = "00"
      @result.breakball = false
      @result.setball = false
      @result.matchball = false
      @result.save
    end

    @newResult = Result.new
    @newResult.game_id =  @result.game_id
    @newResult.set1H = @result.set1H
    @newResult.set1G = @result.set1G
    @newResult.set2H = @result.set2H
    @newResult.set2G = @result.set2G
    @newResult.set3H = @result.set3H
    @newResult.set3G = @result.set3G
    @newResult.gameH = @result.gameH
    @newResult.gameG = @result.gameG
    @newResult.breakball = @result.breakball
    @newResult.setball = @result.setball
    @newResult.matchball = @result.matchball
    
    gameforH = false
    gameforG = false
    case params[:action_code]
      when "G"
        if @result.gameG == "00"
          @newResult.gameG = "15"
        end
        if @result.gameG == "15"
          @newResult.gameG = "30"
        end
        if @result.gameG == "30"
          @newResult.gameG = "40"
        end
        if @result.gameG == "40" 
          if (@result.gameH != "40" and @result.gameH != "AD")
            gameforG = true
          else
            @newResult.gameG = "AD"
            @newResult.gameH = "--"
          end
        end
        if @result.gameG == "AD" 
            gameforG = true
        end
        if @result.gameG == "--" 
            @newResult.gameG = "DU"
            @newResult.gameH = "DU"
        end
        if @result.gameG == "DU" 
           @newResult.gameG = "AD"
           @newResult.gameH = "--"
        end
        
      when "H"
        if @result.gameH == "00"
          @newResult.gameH = "15"
        end
        if @result.gameH == "15"
          @newResult.gameH = "30"
        end
        if @result.gameH == "30"
          @newResult.gameH = "40"
        end
        if @result.gameH == "40"
          if (@result.gameG != "40" and @result.gameG != "AD")
            gameforH = true
          else
            @newResult.gameH = "AD"
            @newResult.gameG = "--"
          end
        end
        if @result.gameH == "AD" 
            gameforH = true
        end
        if @result.gameH == "--" 
            @newResult.gameG = "DU"
            @newResult.gameH = "DU"
        end
        if @result.gameH == "DU" 
           @newResult.gameH = "AD"
           @newResult.gameG = "--"
        end

      when "R"
    end
    
    set1closed = false
    if ((@result.set1H - @result.set1G).abs >= 2) and (@result.set1H >= 6 or @result.set1G >= 6)
      set1closed = true
    end
    set2closed = false
    if ((@result.set2H - @result.set2G).abs >= 2) and (@result.set2H >= 6 or @result.set2G >= 6)
      set2closed = true
    end
    set3closed = false
    if ((@result.set3H - @result.set3G).abs >= 2) and (@result.set3H >= 6 or @result.set3G >= 6)
      set3closed = true
    end

    if !set1closed
      if gameforH
        message = "new Game for H"
        @newResult.set1H = @result.set1H + 1
        @newResult.gameH = "00"
        @newResult.gameG = "00"
      end
      if gameforG
        message = "new Game for G"
        @newResult.set1G = @result.set1G + 1
        @newResult.gameH = "00"
        @newResult.gameG = "00"
      end
    end

    if set1closed and !set2closed
      if gameforH
        message = "new Game for H"
        @newResult.set2H = @result.set2H + 1
        @newResult.gameH = "00"
        @newResult.gameG = "00"
      end
      if gameforG
        message = "new Game for G"
        @newResult.set2G = @result.set2G + 1
        @newResult.gameH = "00"
        @newResult.gameG = "00"
      end
    end

    if set2closed and !set3closed
      if gameforH
        message = "new Game for H"
        @newResult.set3H = @result.set3H + 1
        @newResult.gameH = "00"
        @newResult.gameG = "00"
      end
      if gameforG
        message = "new Game for G"
        @newResult.set3G = @result.set3G + 1
        @newResult.gameH = "00"
        @newResult.gameG = "00"
      end
    end
    

    @newResult.save
    
    @anz = Result.count
    
    home = @newResult.set1H.to_s + " " + @newResult.set2H.to_s + " " + @newResult.set3H.to_s + " " + @newResult.gameH
    guest = @newResult.set1G.to_s + " " + @newResult.set2G.to_s + " " + @newResult.set3G.to_s + " " + @newResult.gameG

  end
  respond_to do |format|
    format.json 
      msg = {:anz => @anz, :HOME => home, :GUEST => guest, :message => message}
      render :json => msg.to_json
  end

end

def getResult
  if params[:game_id]
    @result = Game.find(params[:game_id]).results.last
    msg = [{:s1H => @result.set1H, :s2H=> @result.set2H, :s3H=> @result.set3H, :gameH => @result.gameH, :s1G => @result.set1G, :s2G=> @result.set2G, :s3G=> @result.set3G, :gameG => @result.gameG}]
  else
    msg = [{:message => "game not found"}]
  end
  respond_to do |format|
    format.json 
      render :json => msg.to_json
  end
end


end