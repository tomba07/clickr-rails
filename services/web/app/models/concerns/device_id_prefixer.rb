module DeviceIdPrefixer
  extend ActiveSupport::Concern

  included do
    before_validation :prefix_id_with_type!
  end

  def prefix_id_with_type!
    return if device_id.blank? || device_type.blank?

    prefix = "#{device_type}:"
    id = device_id || ''
    self.device_id = id.start_with?(prefix) ? id : "#{prefix}#{id}"
  end
end
