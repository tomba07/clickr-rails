class Clickr::Task::CreateQuestionResponse
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

    Rails.logger.debug "Trying to create question response for mapping #{
                         mapping.inspect
                       }"

    return @result = create_question_response!(@click, mapping)
  end

  private

  def create_question_response!(click, mapping)
    lesson = @school_class.most_recent_lesson
    question = lesson&.most_recent_question

    if !question&.response_allowed
      Rails
        .logger.debug 'Cannot create question response - no most recent question or response not allowed.'
      return nil
    end

    response_exists =
      QuestionResponse.exists?(
        student_id: mapping.student_id, question: question
      )

    if response_exists
      Rails
        .logger.debug 'Cannot create question response - question response already exists.'
      return nil
    end

    Rails.logger.info "Creating question response for question #{
                        question.inspect
                      }"

    click.create_question_response!(
      student_id: mapping.student_id,
      question: question,
      lesson: lesson,
      school_class: @school_class,
      score: question.score || 1
    )
  end
end
