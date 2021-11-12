module Ask
  module For
    class InoculationsController < ApplicationController
      def index
        fad = inoculation_params

        # TODO: move all this logic to the model
        country = fad[:country] = Country
          .includes(vaccines: :countries).where(reference: fad[:country]).first

        unless fad[:user].nil?
          inoculations = country.inoculations.where(fad).order(appointement_at: :desc)
        end

        aim = %w[name reference composition]
        vaccines = country.vaccines.map do |vaccine|
          locally_fulfilled_inoculations = inoculations
                .where(fulfilled: true, vaccine_id: vaccine.id)
                .count
          rate = 100.0 * locally_fulfilled_inoculations / country.population
          tut = {
            vaccine: vaccine.attributes.select{ |a| a.in? aim },
            delivering_countries: vaccine.countries.map(&:name),
            country_population: country.population,
            locally_fulfilled_inoculations: locally_fulfilled_inoculations,
            coverage: rate,
          }
          # next vaccination booster date if user was provided
          # TODO, add filter to take into account only dates still in future?
          unless fad[:user].nil?
            tut[:next_appointment] = inoculations
              .select{ _1.vaccine_id == vaccine.id }.first
              &.appointement_at&.iso8601
          end

          tut
        end

        render json: vaccines.to_json
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_inoculation
          @inoculation = Inoculation.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def inoculation_params
          params.require(:country)
          params.permit(:country, :inoculation, :user)
        end
    end
  end
end
