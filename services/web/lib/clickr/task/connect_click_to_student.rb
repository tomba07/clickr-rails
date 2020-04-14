class Clickr::Task::ConnectClickToStudent
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
      @school_class.student_device_mappings.where(device_id: @click.device_id)
        .first

    if mapping
      @result = mapping.student
      @click.update!(student: mapping.student)
    end
  end
end
