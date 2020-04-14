class AddUsefulToClicks < ActiveRecord::Migration[6.0]
  def change
    add_column :clicks, :useful, :boolean, default: false
  end
end
