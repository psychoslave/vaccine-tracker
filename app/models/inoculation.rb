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

    swab = %w[name reference composition]
    country.vaccines.map do |vaccine|
      wad = inoculations.select{ _1.vaccine_id == vaccine.id }

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
        inoculation = inoculations.select{ _1.vaccine_id == vaccine.id }.first
        tut[:next_appointment] = inoculation&.appointement_at&.iso8601
        tut[:mandatory_for_user] = inoculation&.mandatory
      end

      tut
    end
  end

  # Create an inoculation entry for the provided user
  # user:: string reference for the user which should be appointed a new inoculation
  # vaccine:: a vaccine instance of the concerned product
  def self.build(user, vaccine)
    # assume same country for people already recorded, or a random one otherwise
    inoculations = Inoculation.includes(:country).where(user: user).order(appointment_at: :desc)
    country = if inoculations.any?
                inoculations.first.country
              else
                Country.all.sample
              end
    date = Faker::Date.between(from: Date.today+1, to: 1.year.from_now)

    Inoculation.new(
      user: user, appointement_at: date, vaccine: vaccine,
      country: country, mandatory: true, fulfilled: false
    )
  end
end
