class AllowNullReferencesForQuestionResponses < ActiveRecord::Migration[6.0]
  def change
    change_column_null :question_responses, :question_id, true
    change_column_null :question_responses, :click_id, true
  end
end
