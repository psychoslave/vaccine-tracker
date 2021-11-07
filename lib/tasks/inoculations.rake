namespace :inoculations do
  desc "Generate a CVS file with fake inoculation entries"
  task gig_cvs: :environment do
    # Assumes that the database was already seeded with vaccines
    raise 'Error: no vaccine present in the database' if Vaccine.count.zero?
    vaccines = Vaccine.all.map(&:reference)
    File.open(way, 'w') do |cvs|
      10_000.times do
        date = Faker::Date.between(from: 1.year.ago, to: 1.year.from_now)
        row = [Faker::Number.number(digits: 10), vaccines.sample, date.iso8601]
        cvs.puts row.join(';')
      end
    end
  end

  desc "Import the inoculation CVS file in the database as inoculation entries"
  task import_cvs: :environment do
  end

  def way
    File.expand_path('../../../db/inoculations.csv', __FILE__)
  end
end
