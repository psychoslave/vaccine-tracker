class InoculationsController < ApplicationController
  before_action :set_inoculation, only: %i[ show edit update destroy ]

  # GET /inoculations or /inoculations.json
  def index
    #@inoculations = Inoculation.all
    @pagy, @inoculations = pagy(Inoculation.all)
  end

  # GET /inoculations/1 or /inoculations/1.json
  def show
  end

  # GET /inoculations/new
  def new
    @inoculation = Inoculation.new
  end

  # GET /inoculations/1/edit
  def edit
  end

  # POST /inoculations or /inoculations.json
  def create
    @inoculation = Inoculation.new(inoculation_params)

    respond_to do |format|
      if @inoculation.save
        format.html { redirect_to @inoculation, notice: "Inoculation was successfully created." }
        format.json { render :show, status: :created, location: @inoculation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inoculation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inoculations/1 or /inoculations/1.json
  def update
    respond_to do |format|
      if @inoculation.update(inoculation_params)
        format.html { redirect_to @inoculation, notice: "Inoculation was successfully updated." }
        format.json { render :show, status: :ok, location: @inoculation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inoculation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inoculations/1 or /inoculations/1.json
  def destroy
    @inoculation.destroy
    respond_to do |format|
      format.html { redirect_to inoculations_url, notice: "Inoculation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inoculation
      @inoculation = Inoculation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def inoculation_params
      params.require(:inoculation).permit(:user, :appointement_at, :mandatory, :fulfilled, :vaccine_id, :country_id)
    end
end
