class Click < ApplicationRecord
  include DeviceIdPrefixer

  strip_attributes
  has_one :question_response, dependent: :destroy
  belongs_to :student, optional: true

  scope :newest_first, -> { order(created_at: :desc) }
  scope :spam,
        lambda {
          newest_first.where('created_at > ?', most_recent_useful_created_at)
        }

  validates :device_type, presence: true
  validates :device_id, presence: true

  def name
    id
  end

  def self.most_recent_useful_created_at
    newest_first.where(useful: true).first&.created_at || DateTime.new(1970)
  end

  def self.spam_count
    spam.count
  end
end
