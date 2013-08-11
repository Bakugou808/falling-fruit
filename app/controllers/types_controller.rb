class TypesController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource

  # GET /types
  # GET /types.json
  def index
    @types = Type.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @types }
      format.csv { render csv: @types }
    end
  end

  def merge
    from = Type.find(params[:id].to_i)
    to = Type.find(params[:into_id].to_i)
    LocationsType.where("type_id = ?",from.id).each{ |lt|
      lt.type = to
      lt.save
    }
    from.destroy
    respond_to do |format|
      format.html { redirect_to types_url, :notice => "Type #{from.id} was successfully merged into type #{to.id}" }
      format.json { head :no_content }
    end
  end

  # GET /types/new
  # GET /types/new.json
  def new
    @type = Type.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @type }
    end
  end

  # GET /types/1/edit
  def edit
    @type = Type.find(params[:id])
  end

  # POST /types
  # POST /types.json
  def create
    @type = Type.new(params[:type])

    respond_to do |format|
      if @type.save
        format.html { redirect_to types_path, notice: 'Type was successfully created.' }
        format.json { render json: @type, status: :created, location: @type }
      else
        format.html { render action: "new" }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /types/1
  # PUT /types/1.json
  def update
    @type = Type.find(params[:id])

    respond_to do |format|
      if @type.update_attributes(params[:type])
        format.html { redirect_to types_path, notice: 'Type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /types/1
  # DELETE /types/1.json
  def destroy
    @type = Type.find(params[:id])
    @type.destroy

    respond_to do |format|
      format.html { redirect_to types_url }
      format.json { head :no_content }
    end
  end
end
