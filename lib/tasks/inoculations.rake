namespace :inoculations do
  desc "Generate a CVS file with fake inoculation entries"
  task gig_cvs: :environment do
    # Assumes that the database was already seeded with vaccines
    raise 'Error: no vaccine present in the database' if Vaccine.count.zero?
    vaccines = Vaccine.all.map(&:reference)
    File.open(way, 'w') do |cvs|
      10_000.times do
        date = Faker::Date.between(from: 1.year.ago, to: 1.year.from_now)
        row = [Faker::Number.number(digits: 12), vaccines.sample, date.iso8601]
        cvs.puts row.join(';')
      end
    end
  end

  desc "Import the inoculation CVS file in the database as inoculation entries"
  task import_cvs: :environment do
    # Dirty efficient way to cache values that are going to be heavily tapped
    Country_ids = Country.all.map(&:id)
    Booleans = [true, false]
    Vaccine_ids = Vaccine.all.map{|ens| [ens.reference, ens.id]}.to_h
    # Thanks to Brian Armstrong for this elegant solution of performant CVS processing
    # https://stackoverflow.com/questions/5557157/best-way-to-work-with-large-amounts-of-csv-data-quickly#7936057
    lines = []
    IO.foreach(way) do |line|
      lines << line
      if lines.size >= 1000
        lines = FasterCSV.parse(lines.join) rescue next
        store lines
        lines = []
      end
    end

    store lines
  end

  # Transform given CSV lines into inoculation hash entries and insert them
  def store(lines)
    Inoculation.insert_all lines.map{|line| record line.split ?;}
  end

  # produce a hash that can be inserted as inoculation entry from an array
  # of `[user_reference, vaccine_reference, appointement_date]`
  def record(item)
    {
      user: item.first,
      appointement_at: Date.parse(item.last),
      mandatory: Booleans.sample,
      fulfilled: Booleans.sample,
      vaccine_id: Vaccine_ids[item.second],
      country_id: Country_ids.sample,
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  # return the path to the CSV file holding inoculation entries
  def way
    File.expand_path('../../../db/inoculations.csv', __FILE__)
  end
end
