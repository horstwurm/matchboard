class CredentialsController < ApplicationController
  before_action :set_credential, only: [:show, :edit, :update, :destroy]

  # GET /credentials
  # GET /credentials.json
  def index
    
    if params[:id]
      @c = Credential.find(params[:id])
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

    if params[:user_id]
      @user = User.find(params[:user_id])
      @credentials = @user.credentials
    end

  end

  # GET /credentials/1
  # GET /credentials/1.json
  def show
  end

  # GET /credentials/new
  def new
    @credential = Credential.new
  end

  # GET /credentials/1/edit
  def edit
  end

  # POST /credentials
  # POST /credentials.json
  def create
    @credential = Credential.new(credential_params)

    respond_to do |format|
      if @credential.save
        format.html { redirect_to user_path(:id => @credential.user_id, :topic => "Zugriffsberechtigungen"), notice: (I18n.t act_create) }
        format.json { render :show, status: :created, location: @credential }
      else
        format.html { render :new }
        format.json { render json: @credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /credentials/1
  # PATCH/PUT /credentials/1.json
  def update
    respond_to do |format|
      if @credential.update(credential_params)
        format.html { redirect_to user_path(:id => @credential.user_id, :topic => "Zugriffsberechtigungen"), notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @credential }
      else
        format.html { render :edit }
        format.json { render json: @credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credentials/1
  # DELETE /credentials/1.json
  def destroy
    @credential.destroy
    respond_to do |format|
      format.html { redirect_to user_path(:id => @credential.user_id, :topic => "Zugriffsberechtigungen"), notice: (I18n.t ::act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credential
      @credential = Credential.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def credential_params
      params.require(:credential).permit(:domain, :user_id, :right, :access)
    end
end
