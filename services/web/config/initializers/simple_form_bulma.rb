# frozen_string_literal: true

# Uncomment this and change the path if necessary to include your own
# components.
# See https://github.com/plataformatec/simple_form#custom-components
# to know more about custom components.
# Dir[Rails.root.join('lib/components/**/*.rb')].each { |f| require f }

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  # Default class for buttons
  config.button_class = 'button'

  # Define the default class of the input wrapper of the boolean input.
  config.boolean_label_class = 'label'

  # How the label text should be generated altogether with the required text.
  config.label_text = lambda { |label, required, explicit_label| "#{label} #{required}" }

  # Define the way to render check boxes / radio buttons with labels.
  config.boolean_style = :inline

  # You can wrap each item in a collection of radio/check boxes with a tag
  config.item_wrapper_tag = :div

  # Defines if the default input wrapper class should be included in radio
  # collection wrappers.
  config.include_default_input_wrapper_class = false

  # CSS class to add for error notification helper.
  config.error_notification_class = 'notification is-danger'

  # Method used to tidy up errors. Specify any Rails Array method.
  # :first lists the first message for each field.
  # :to_sentence to list all errors for each field.
  config.error_method = :to_sentence

  # You can define which elements should obtain additional classes
  config.generate_additional_classes_for = []


  config.wrappers :default, tag: 'div', class: 'field' do |field|
    field.use :label, class: 'label'

    field.wrapper tag: 'div', class: 'control' do |control|
      control.use :html5
      control.use :input, class: 'input', error_class: 'is-danger', valid_class: 'is-success'
      control.use :placeholder
      control.optional :maxlength
      control.optional :minlength
      control.optional :pattern
      control.optional :min_max
      control.optional :readonly
    end

    field.use :full_error, wrap_with: { tag: 'p', class: 'help is-danger' }
    field.use :hint, wrap_with: { tag: 'p', class: 'help' }
  end

  config.wrappers :custom_select, tag: 'div', class: 'field' do |field|
    field.use :label, class: 'label'

    field.wrapper tag: 'div', class: 'control'  do |control|
      control.wrapper tag: 'div', class: 'select' do |select|
        select.use :html5
        select.use :input, class: 'input', error_class: 'is-danger', valid_class: 'is-success'
        select.use :placeholder
        select.optional :readonly
      end
    end

    field.use :full_error, wrap_with: { tag: 'p', class: 'help is-danger' }
    field.use :hint, wrap_with: { tag: 'p', class: 'help' }
  end

  config.wrappers :custom_boolean, tag: 'div', class: 'field' do |field|
    field.wrapper tag: 'div', class: 'control'  do |control|
      control.wrapper tag: 'label', class: 'checkbox' do |label|
        label.use :html5
        label.use :input, error_class: 'is-danger', valid_class: 'is-success'
        label.optional :readonly
        label.use :label_text
      end
    end

    field.use :full_error, wrap_with: { tag: 'p', class: 'help is-danger' }
    field.use :hint, wrap_with: { tag: 'p', class: 'help' }
  end


  # Custom wrappers for input types. This should be a hash containing an input
  # type as key and the wrapper that will be used for all inputs with specified type.
  config.wrapper_mappings = {
    select:       :custom_select,
    boolean:      :custom_boolean,
  }
end
