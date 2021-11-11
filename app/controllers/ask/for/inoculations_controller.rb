module Ask
  module For
    class InoculationsController < ApplicationController
      def index
        fad = inoculation_params

        fad[:country] = Country.where(reference: fad[:country]).first
        @inoculations = Inoculation.where(fad).order(fulfilled: :asc, mandatory: :desc)
        render json: @inoculations
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
