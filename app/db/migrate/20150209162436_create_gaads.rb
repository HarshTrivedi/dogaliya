class CreateGaads < ActiveRecord::Migration
  def change
    create_table :gaads do |t|
			t.string :shlok
      t.timestamps
    end
  end
end
