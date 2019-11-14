class Click < ApplicationRecord
  strip_attributes
  has_one :question_response

  validates :device_type, presence: true
  validates :device_id, presence: true

  def name
      id
  end
end
