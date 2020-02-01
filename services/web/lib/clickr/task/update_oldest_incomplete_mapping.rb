class Clickr::Task::UpdateOldestIncompleteMapping
  attr_reader :result

  def self.call(click)
    handler = self.new(click)
    handler.call
    handler
  end

  def initialize(click)
    @click = click
  end

  def call
    mapping = StudentDeviceMapping.oldest_incomplete(@click.device_id)

    if !mapping
      Rails.logger.debug 'Cannot create mapping - no incomplete one found.'
      return @result = nil
    end

    Rails.logger.info "Updating incomplete mapping #{mapping.inspect}"
    mapping.update!(
      device_type: @click.device_type, device_id: @click.device_id
    )

    @result = mapping
  end
end
