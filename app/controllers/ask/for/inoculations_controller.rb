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
        fulfilled_inoculations = inoculations.where(fulfilled: true)

        aim = %w[name reference composition]
        vaccines = country.vaccines.map do |vaccine|
          wad = inoculations
            .select{ _1.vaccine_id == vaccine.id }

          # TODO, consider further optimization with a counter cache
          locally_fulfilled_inoculations = wad.nil? ? 0 : wad.count
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

      # GET /inoculations/new
      def new
        params.require(:user)
        params.require(:vaccine)
        fad = params.permit(:vaccine, :user)

        # if vaccine reference is not valid, render error
        vaccine = Vaccine.where(reference: fad[:vaccine]).first
        unless vaccine
          raise ActionController::RoutingError.new('Vaccine Not Found')
          render html: 'Invalid vaccine reference'
          head :bad_request
          return
        end

        # assume same country for people already recorded, or a random one otherwise
        inoculations = Inoculation.includes(:country).where(user: fad[:user]).order(appointment_at: :desc)
        country = if inoculations.any?
                    inoculations.first.country
                  else
                    Country.all.sample
                  end
        date = Faker::Date.between(from: Date.today+1, to: 1.year.from_now)
        item = Inoculation.new(
          user: fad[:user], appointement_at: date, vaccine: vaccine,
          country: country, mandatory: true, fulfilled: false
        )
        if item.save
          head :ok
        else
          render html: 'Entry could not be saved'
          head :bad_request
        end
      end

      protected
        # Only allow a list of trusted parameters through.
        def inoculation_params
          params.require(:country)
          params.permit(:country, :inoculation, :user)
        end
    end
  end
end
