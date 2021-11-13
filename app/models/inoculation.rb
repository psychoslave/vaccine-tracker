class Inoculation < ApplicationRecord
  belongs_to :vaccine
  belongs_to :country

  # Generate a report of vaccination status for the sought criteria
  #
  # sought:: a hash table providing desired criteria to apply
  # +sought[:country]+:: mandatory, the country to target in this report
  # +sought[:user]+:: optional, if provided, used to fill a +next_appointment+ attribute
  def self.report(sought)
    country = sought[:country] = Country
      .includes(vaccines: :countries).where(reference: sought[:country]).first

    unless sought[:user].nil?
      inoculations = country.inoculations.where(sought).order(appointement_at: :desc)
    end
    fulfilled_inoculations = inoculations.where(fulfilled: true)

    swab = %w[name reference composition]
    country.vaccines.map do |vaccine|
      wad = inoculations
        .select{ _1.vaccine_id == vaccine.id }

      # TODO, consider further optimization with a counter cache
      locally_fulfilled_inoculations = wad.nil? ? 0 : wad.count
      rate = 100.0 * locally_fulfilled_inoculations / country.population
      tut = {
        vaccine: vaccine.attributes.select{ |a| a.in? swab },
        delivering_countries: vaccine.countries.map(&:name),
        country_population: country.population,
        locally_fulfilled_inoculations: locally_fulfilled_inoculations,
        coverage: rate,
      }
      # next vaccination booster date if user was provided
      # TODO, consider filtering outdated appointements
      unless sought[:user].nil?
        tut[:next_appointment] = inoculations
          .select{ _1.vaccine_id == vaccine.id }.first
        &.appointement_at&.iso8601
      end

      tut
    end
  end
end
