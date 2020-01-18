class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.references :survivor, null: false, foreign_key: true
      t.decimal :lat
      t.decimal :lng
    end
  end
end
