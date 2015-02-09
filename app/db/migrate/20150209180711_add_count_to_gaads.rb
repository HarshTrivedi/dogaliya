class AddCountToGaads < ActiveRecord::Migration
  def up
  	add_column :gaads, :frequency, :integer
  end

  def down
  	remove_column :gaads, :frequency
  end
end
