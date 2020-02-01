class Clickr::Task::CreateQuestionResponses
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
    mappings =
      StudentDeviceMapping.includes(:school_class).where(
        device_id: @click.device_id
      )

    Rails.logger.debug "Trying to create question response for #{
                         mappings.size
                       } mappings"

    responses =
      mappings.map { |mapping| create_question_response!(@click, mapping) }
    return @result = responses.compact
  end

  private

  def create_question_response!(click, mapping)
    school_class = mapping.school_class
    lesson = school_class.most_recent_lesson
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
      school_class: school_class,
      score: question.score || 1
    )
  end
end
