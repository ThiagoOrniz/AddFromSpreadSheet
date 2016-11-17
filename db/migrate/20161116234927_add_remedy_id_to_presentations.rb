class AddRemedyIdToPresentations < ActiveRecord::Migration
  def change
    add_column :presentations, :remedy_id, :integer
  end
end
