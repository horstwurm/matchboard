class MobjectsController < ApplicationController
  before_action :set_mobject, only: [:show, :edit, :update, :destroy]

  # GET /mobjects
  def index

    @controller_name = controller_name
    if params[:mtype]
      session[:mtype] = params[:mtype]
    end
    @mobjects = Mobject.search(current_user, nil, nil, params[:filter_id], session[:mtype], params[:search]).order(created_at: :desc).page(params[:page]).per_page(50)
    @mobanz = @mobjects.count
    @mtype = session[:mtype]
    @param = params[:filter_id]
    @search = params[:search]

     counter = 0 
     @locs = []
     @wins = []
     @mobjects.each do |u|

        if u.longitude and u.latitude and u.geo_address
       
          @locs << [u.name, u.latitude, u.longitude]

          if u.mdetails.count > 0
            if u.mdetails.first.avatar_file_name
              img = u.mdetails.first.avatar(:small)
            else
              img = File.join(Rails.root, "/app/assets/images/no_pic.jpg")
            end
          else
            img = File.join(Rails.root, "/app/assets/images/no_pic.jpg")
          end
          @wins << ["<img src='" + img + "'><br><h3>" + u.name + "</h3><p>" + u.geo_address + "</p>"]

        end

        counter = counter + 1
      end

  end

  # GET /mobjects/1
  def show
    
    if !params[:topic]
      @topic = "objekte_info"
    else
      @topic = params[:topic]
    end

  end

  # GET /mobjects/new
  def new
    @mobject = Mobject.new
    @mobject.status = "OK"
    @mobject.mtype = params[:mtype]
    @mobject.active = true
    @mobject.online_pub = false
    @mobject.name = @mobject.mtype
    @mobject.description = "Beschreibung..."
    @mobject.homepage = "www.xyz.ch"

    if params[:user_id]
      @mobject.owner_id = params[:user_id]
      @mobject.owner_type = "User"
    end
    if params[:company_id]
      @mobject.owner_id = params[:company_id]
      @mobject.owner_type = "Company"
    end
    @mobject.address1 = @mobject.owner.address1
    @mobject.address2 = @mobject.owner.address2
    @mobject.address3 = @mobject.owner.address3
    @mobject.geo_address = @mobject.owner.geo_address
    @mobject.longitude = @mobject.owner.longitude
    @mobject.latitude = @mobject.owner.latitude
    
  end

  # GET /mobjects/1/edit
  def edit
  end

  # POST /mobjects
  def create
    @mobject = Mobject.new(mobject_params)

    if @mobject.save

      # STD Berechtigung erstellen
      if @mobject.mtype == "sponsorantraege"
        if @mobject.owner.company_params.first.role_sponsoring
          u = User.where('email=?',@mobject.owner.company_params.first.role_sponsoring).first
          if u
            m = Madvisor.new
            m.mobject_id = @mobject.id
            m.user_id = u.id
            m.role = @mobject.mtype 
            m.grade = "default"
            m.save
          end
        end
        # Bestätigungsemail an Antragsteller erstellen
        if @mobject.requester_type == "User"
          @user = User.find(@mobject.requester_id)
          @status = @mobject.sponsorenstatus
          UserMailer.user_sponsoring_info(@user, @mobject, @status).deliver_now
        end
        if @mobject.requester_type == "Company"
          @company = Company.find(@mobject.requester_id)
          @status = @mobject.sponsorenstatus
          UserMailer.user_sponsoring_info(@company.user, @mobject, @status).deliver_now
        end
      end

      redirect_to @mobject, notice: (I18n.t :act_create)
    else
      render :new
    end
  end

  # PUT /mobjects/1
  def update
    if @mobject.update(mobject_params)
      redirect_to @mobject, notice: (I18n.t :act_update)
    else
      render :edit
    end
  end

  # DELETE /mobjects/1
  def destroy
    @ownerid = @mobject.owner_id
    @ownertype = @mobject.owner_type
    @mtype = @mobject.mtype
    @msubtype = @mobject.msubtype
    @mobject.destroy
    if @ownertype == "User"
      redirect_to user_path(:id => @ownerid, :topic => "personen_"+@mtype), notice: (I18n.t :act_delete)
    else
      redirect_to company_path(:id => @ownerid, :topic => "institutionen_"+@mtype), notice: (I18n.t :act_delete)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mobject
      @mobject = Mobject.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def mobject_params
      params.require(:mobject).permit(:mini, :maxi, :alert, :alertlow, :sum_paufwand_ist, :sum_pkosten_ist, :sum_paufwand_plan, :sum_pkosten_plan, :risk, :quality, :costinfo, :parent, :online_pub, :eventpart, :owner_id, :owner_type, :mtype, :msubtype, :mcategory_id, :company_id, :user_id, :status, :name, :description, :reward, :interest_rate, :due_date, :date_from, :date_to, :time_from, :time_to, :days, :amount, :price, :tasks, :skills, :offers, :social, :price_reg, :price_new, :active, :signage, :keywords, :homepage, :address1, :address2, :address3, :latitude, :longitude, :geo_address, :allow, :allowdays, :sponsorenart, :sponsorenperiode, :sponsorenbetragantrag, :sponsorenbetraggenehmigt,:sponsorenantwort, :sponsorenstatus, :sponsorenok, :requester_id, :requester_type)
    end

end