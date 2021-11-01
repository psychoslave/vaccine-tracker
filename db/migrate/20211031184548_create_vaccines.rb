class CreateVaccines < ActiveRecord::Migration[6.1]
  def change
    create_table :vaccines do |t|
      t.string :name
      t.string :reference
      t.text :composition
      t.integer :delay

      t.timestamps
    end

    create_join_table :countries, :vaccines do |t|
      t.index :country_id
      t.index :vaccine_id
    end
  end
end
