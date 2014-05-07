class CategorizationsController < ApplicationController
  before_action :set_categorization, only: [:show, :edit, :update, :destroy]

  # GET /categorizations
  # GET /categorizations.json
  def index
    @categorizations = Categorization.all
  end

  # GET /categorizations/1
  # GET /categorizations/1.json
  def show
  end

  # GET /categorizations/new
  def new
    @categorization = Categorization.new
  end

  # GET /categorizations/1/edit
  def edit
  end

  # POST /categorizations
  # POST /categorizations.json
  def create
    @categorization = Categorization.new(categorization_params)

    respond_to do |format|
      if @categorization.save
        format.html { redirect_to @categorization, notice: 'Categorization was successfully created.' }
        format.json { render action: 'show', status: :created, location: @categorization }
      else
        format.html { render action: 'new' }
        format.json { render json: @categorization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categorizations/1
  # PATCH/PUT /categorizations/1.json
  def update
    respond_to do |format|
      if @categorization.update(categorization_params)
        format.html { redirect_to @categorization, notice: 'Categorization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @categorization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categorizations/1
  # DELETE /categorizations/1.json
  def destroy
    @categorization.destroy
    respond_to do |format|
      format.html { redirect_to categorizations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_categorization
      @categorization = Categorization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def categorization_params
      params.require(:categorization).permit(:todo_id, :category_id)
    end
end
