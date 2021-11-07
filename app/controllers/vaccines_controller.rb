class VaccinesController < ApplicationController
  before_action :set_vaccine, only: %i[ show destroy ]
  before_action :set_vaccine_with_countries, only: %i[ edit update ]

  # GET /vaccines or /vaccines.json
  def index
    @vaccines = Vaccine.all
  end

  # GET /vaccines/1 or /vaccines/1.json
  def show
  end

  # GET /vaccines/new
  def new
    @vaccine = Vaccine.new
    set_country_selection
  end

  # GET /vaccines/1/edit
  def edit
  end

  # POST /vaccines or /vaccines.json
  def create
    @vaccine = Vaccine.new(vaccine_params)

    respond_to do |format|
      if @vaccine.save
        format.html { redirect_to @vaccine, notice: "Vaccine was successfully created." }
        format.json { render :show, status: :created, location: @vaccine }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vaccine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vaccines/1 or /vaccines/1.json
  def update
    respond_to do |format|
      if @vaccine.update(vaccine_params)
        format.html { redirect_to @vaccine, notice: "Vaccine was successfully updated." }
        format.json { render :show, status: :ok, location: @vaccine }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vaccine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vaccines/1 or /vaccines/1.json
  def destroy
    @vaccine.destroy
    respond_to do |format|
      format.html { redirect_to vaccines_url, notice: "Vaccine was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vaccine
      @vaccine = Vaccine.find(params[:id])
    end

    def set_vaccine_with_countries
      @vaccine = Vaccine.includes(:countries).find(params[:id])
      set_country_selection
    end

    def set_country_selection
      @selectable_countries = Country.all.map{|c| [c.name, c.id]}
      @selected_countries = @vaccine.countries&.map(&:id) || []
    end

    # Only allow a list of trusted parameters through.
    def vaccine_params
      tut = params.require(:vaccine).permit(:name, :reference, :composition, :delay, countries: [])
      countries = tut[:countries].select{|c| c.match? /\d+/}
      tut[:countries] = Country.where(id: countries)
      tut
    end
end
