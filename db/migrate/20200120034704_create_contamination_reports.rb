class CreateContaminationReports < ActiveRecord::Migration[6.0]
  def change
    create_table :contamination_reports do |t|
      t.references :accuser, null: false, foreign_key: { to_table: :survivors }
      t.references :suspect, null: false, foreign_key: { to_table: :survivors }

      t.timestamps
    end
  end
end
