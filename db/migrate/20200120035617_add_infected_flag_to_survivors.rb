class AddInfectedFlagToSurvivors < ActiveRecord::Migration[6.0]
  def change
    add_column :survivors, :infected, :boolean, default: false 
    add_index :contamination_reports, [:accuser_id, :suspect_id], unique: true
  end
end
