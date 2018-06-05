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
    @mdetail.sequence = @mdetail.mobject.mdetails.count
    
  end

  # GET /mdetails/1/edit
  def edit
    @mdetail.status = "changed"
  end

  # POST /mdetails
  def create
    @mdetail = Mdetail.new(mdetail_params)
    if @mdetail.save
      redirect_to mobject_path(:id => @mdetail.mobject_id, :topic => "objekte_details"), notice: (I18n.t :act_create) 
    else
      render :new
    end
  end

  # PUT /mdetails/1
  def update
    if @mdetail.update(mdetail_params)
      redirect_to mobject_path(:id => @mdetail.mobject_id, :topic => "objekte_details"), notice: (I18n.t :act_update) 
    else
      render :edit
    end
  end

  # DELETE /mdetails/1
  def destroy
    @id = @mdetail.mobject_id
    @type = @mdetail.mtype
    @mdetail.destroy
    redirect_to mobject_path(:id => @id, :topic => "objekte_details"), notice: (I18n.t t :act_delete) 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mdetail
      @mdetail = Mdetail.find(params[:id])
    end

    def mdetail_params
      params.require(:mdetail).permit(:sequence, :status, :mobject_id, :name, :description, :avatar, :document, :video, :mtype)
    end

end
