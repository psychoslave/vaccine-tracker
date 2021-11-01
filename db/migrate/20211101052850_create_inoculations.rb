class CreateInoculations < ActiveRecord::Migration[6.1]
  def change
    create_table :inoculations do |t|
      t.string :user
      t.date :appointement_at
      t.boolean :mandatory
      t.boolean :fulfilled
      t.references :vaccine, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end
  end
end
