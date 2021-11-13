module Ask
  module For
    class InoculationsController < ApplicationController
      def index
        render json: Inoculation.report(report_params).to_json
      end

      # GET /inoculations/new
      def new
        fad = hatch_params

        # if vaccine reference is not valid, render error
        vaccine = Vaccine.where(reference: fad[:vaccine]).first
        raise ActiveRecord::RecordNotFound unless vaccine

        item = Inoculation.build(fad[:user], vaccine)
        raise ActiveRecord::RecordNotFound unless vaccine unless item.save!

        head :created

      rescue ActiveRecord::RecordNotFound
        render json: {error: 'Invalid vaccine reference'}.to_json, status: :unprocessable_entity
      rescue ActiveRecord::RecordNotSaved
        render json: {error: 'The inoculation could not be saved'}.to_json, status: :internal_server_error
      end

      protected
        # Ensure that country is present, and allow it together with user
        def report_params
          params.require(:country)
          params.permit(:country, :user)
        end

        # Ensure that user and country and allow them
        def hatch_params
          %i[user vaccine].each{ params.require(_1) }
          params.permit(:vaccine, :user)
        end
    end
  end
end
