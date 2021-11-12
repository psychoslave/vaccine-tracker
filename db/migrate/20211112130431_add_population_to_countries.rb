class AddPopulationToCountries < ActiveRecord::Migration[6.1]
  def change
    add_column :countries, :population, :integer
  end
end
