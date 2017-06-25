class MdetailsController < ApplicationController
  before_action :set_mdetail, only: [:show, :edit, :update, :destroy]

  # GET /mdetails
  def index
    @mdetails = Mdetail.all
  end

  # GET /mdetails/1
  def show
  end

  # GET /mdetails/new
  def new
    @mdetail = Mdetail.new
    @mdetail.mobject_id = params[:mobject_id]
    if params[:mtype]
      @mdetail.mtype = params[:mtype]
    else
      @mdetail.mtype = "details"
    end
    @mdetail.textoptions = "text"
    @mdetail.sequence = 0
    
  end

  # GET /mdetails/1/edit
  def edit
    @mdetail.status = "changed"
  end

  # POST /mdetails
  def create
    @mdetail = Mdetail.new(mdetail_params)
    if @mdetail.save
      redirect_to mobject_path(:id => @mdetail.mobject_id, :topic => @mdetail.mtype), notice: (I18n.t :erfolgreichgespeichert) 
    else
      render :new
    end
  end

  # PUT /mdetails/1
  def update
    if @mdetail.update(mdetail_params)
      redirect_to mobject_path(:id => @mdetail.mobject_id, :topic => @mdetail.mtype), notice: (I18n.t :erfolgreichgeaendert) 
    else
      render :edit
    end
  end

  # DELETE /mdetails/1
  def destroy
    @id = @mdetail.mobject_id
    @type = @mdetail.mtype
    @mdetail.destroy
    redirect_to mobject_path(:id => @id, :topic => @type), notice: (I18n.t :erfolgreichgeloescht) 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mdetail
      @mdetail = Mdetail.find(params[:id])
    end

    def mdetail_params
      params.require(:mdetail).permit(:headline, :textoptions, :sequence, :status, :mobject_id, :name, :description, :avatar, :document, :mtype)
    end

end
