class Clickr::Task::UpdateOldestIncompleteMapping
  attr_reader :result

  def self.call(click, school_class = CurrentSchoolClass.get)
    handler = self.new(click, school_class)
    handler.call
    handler
  end

  def initialize(click, school_class)
    @click = click
    @school_class = school_class
  end

  def call
    return @result = nil if (!@school_class || !@click)

    mapping =
      StudentDeviceMapping.oldest_incomplete(@click.device_id, @school_class)

    if !mapping
      Rails.logger.debug 'Cannot create mapping - no incomplete one found.'
      return @result = nil
    end

    Rails.logger.info "Updating incomplete mapping #{mapping.inspect}"
    StudentDeviceMapping.transaction do
      mapping.update!(
        device_type: @click.device_type, device_id: @click.device_id
      )
      @click.update!(useful: true)
    end

    @result = mapping
  end
end
