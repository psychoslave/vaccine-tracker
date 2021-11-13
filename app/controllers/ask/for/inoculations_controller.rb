module Ask
  module For
    class InoculationsController < ApplicationController
      def index
        render json: Inoculation.report(report_params).to_json
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
        # Ensure that country is present, and allow it together with user
        def report_params
          params.require(:country)
          params.permit(:country, :user)
        end
    end
  end
end
