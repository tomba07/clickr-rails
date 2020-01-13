class AddResponseAllowedToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions,
               :response_allowed,
               :boolean,
               null: false, default: true
  end
end
