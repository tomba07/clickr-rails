class Click < ApplicationRecord
  include DeviceIdPrefixer

  strip_attributes
  has_one :question_response, dependent: :destroy

  scope :newest_first, ->() { order(created_at: :desc) }

  validates :device_type, presence: true
  validates :device_id, presence: true

  def name
    id
  end
end
