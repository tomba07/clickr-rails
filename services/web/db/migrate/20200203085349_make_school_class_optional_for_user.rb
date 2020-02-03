class MakeSchoolClassOptionalForUser < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :school_class_id, :integer, null: true, on_delete: :nullify
  end

  def down
    # do nothing
  end
end
