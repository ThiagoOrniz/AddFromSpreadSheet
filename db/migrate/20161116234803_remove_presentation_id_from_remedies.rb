class RemovePresentationIdFromRemedies < ActiveRecord::Migration
  def change
    remove_column :remedies, :presentation_id, :integer
  end
end
