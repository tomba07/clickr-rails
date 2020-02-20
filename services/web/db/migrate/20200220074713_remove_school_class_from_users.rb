class RemoveSchoolClassFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :school_class_id
  end
end
