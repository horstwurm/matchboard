class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  $branchen_codes = []

  # GET /companies
  def index

    @controller_name = controller_name
    
    if params[:page]
      session[:page] = params[:page]
    end
    
    @companies = Company.search(params[:filter_id], params[:search]).order(created_at: :desc).page(params[:page]).per_page(10)
    @companz = @companies.count
   counter = 0 
   @locs = []
   @wins = []
   @companies.each do |c|
      if c.longitude and c.latitude and c.geo_address
        @locs << [c.name, c.latitude, c.longitude.to_s]
        @wins << ["<img src=" + c.avatar(:small) + "<br><h3>" + c.name + "</h3><p>" + c.geo_address + "</p>"]
      end
    end

  end

  # GET /companies/1
  def show

     if params[:topic]
       @topic = params[:topic]
     else 
       @topic = "institutionen_info"
     end 
    
    @mtypes = Mobject.select("mtype").distinct
    @stats = [["Aktivtäten","Anzahl"]]
    @stats << ["Partnerlinks", @company.partner_links.count ]
    @mtypes.each do |t|
      @text = t.mtype
      @anz = @company.mobjects.where('mtype=?',t.mtype).count
      if @anz and @anz > 0
        @stats << [@text, @anz]
      end
    end

  end

  # GET /companies/new
  def new
      @company = Company.new
      @company.user_id = params[:user_id]
      @company.active = true
      @company.status = "OK"
      @company.partner = false
  end

  # GET /companies/1/edit
  def edit
    #@company.status = "changed"
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to user_path(:id => @company.user_id, :topic => "personen_institutionen"), notice: (I18n.t :act_create)
      # redirect_to @company, notice: 'Company was successfully created.'
    else
      render :new
    end
  end

  # PUT /companies/1
  def update
    if @company.update(company_params)
      redirect_to @company, notice: (I18n.t :act_update)
    else
      render :edit
    end
  end

  # DELETE /companies/1
  def destroy
    @us = @company.user_id
    @company.destroy
    redirect_to user_path(:id => @us, :topic => "personen_institutionen"),  notice: (I18n.t :act_delete)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end
    
    def company_params
      params.require(:company).permit(:partner, :status, :active, :name, :homepage, :mcategory_id, :stichworte, :user_id, :description, :address1, :address2, :address3, :geo_address, :longitude, :latitude, :phone1, :phone2, :avatar, :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at)
    end

end
