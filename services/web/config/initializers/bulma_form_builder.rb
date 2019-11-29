# Based on https://medium.com/@dyanagi/a-bulma-form-builder-for-ruby-on-rails-applications-aef780808bab
# Additions:
# - Add `field`` div around input elements
# - Show error beneath each input element
class BulmaFormBuilder < ActionView::Helpers::FormBuilder
  alias_method :parent_label, :label
  # Label for most types of input tags (text, password, email...)
  def label(method, text = nil, options = {}, &block)
    super(method, text, merge_class(options, 'label'), &block)
  end

  def text_field(method, options = {})
    wrapper = options[:no_field] ? method(:identity) : method(:div_field)
    wrapper.call do
      (block_given? ? yield : nothing) + div_control do
        super(method, merge_class(options, 'input')) + errors(method)
      end
    end
  end

  def text_field_with_label(method, options = {})
    text_field(method, options) do
      label(method)
    end
  end

  def number_field(method, options = {})
    wrapper = options[:no_field] ? method(:identity) : method(:div_field)
    wrapper.call do
      (block_given? ? yield : nothing) + div_control do
        super(method, merge_class(options, 'input')) + errors(method)
      end
    end
  end

  def number_field_with_label(method, options = {})
    number_field(method, options) do
      label(method)
    end
  end

  # Email field with an icon
  def email_field(method, options = {})
    wrapper = options[:no_field] ? method(:identity) : method(:div_field)
    wrapper.call do
      (block_given? ? yield : nothing) + div_control_for_icons do
        super(method, merge_class(options, 'input')) + email_icon + errors(method)
      end
    end
  end

  # Email field with an icon, plus the label for it
  def email_field_with_label(method, options = {})
    email_field(method, options) do
      label(method)
    end
  end

  # Password field with an icon
  def password_field(method, options = {})
    wrapper = options[:no_field] ? method(:identity) : method(:div_field)
    wrapper.call do
      (block_given? ? yield : nothing) + div_control_for_icons do
        super(method, merge_class(options, 'input')) + password_icon + errors(method)
      end
    end
  end

  # Password field with an icon, plus the label for it
  def password_field_with_label(method, options = {})
    password_field(method, options) do
      label(method)
    end
  end

  # Omit &block (custom option rendering)
  def select(method, choices = nil, options = {}, html_options = {})
    wrapper = options[:no_field] ? method(:identity) : method(:div_field)
    wrapper.call do
      (block_given? ? yield : nothing) + div_control do
        div_select do
          super
        end + errors(method)
      end
    end
  end

  # Omit &block (custom option rendering)
  def select_with_label(method, choices = nil, options = {}, html_options = {})
    select(method, choices = nil, options, html_options) do
      label(method)
    end
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    wrapper = options[:no_field] ? method(:identity) : method(:div_field)
    wrapper.call do
      (block_given? ? yield : nothing) + div_control do
        div_select do
          super
        end + errors(method)
      end
    end
  end

  def collection_select_with_label(method, collection, value_method, text_method, options = {}, html_options = {})
    collection_select(method, collection, value_method, text_method, options, html_options) do
      label(method)
    end
  end

  def check_box_with_label(method, options = {}, checked_value = "1", unchecked_value = "0")
    wrapper = options[:no_field] ? method(:identity) : method(:div_field)
    wrapper.call do
      div_control do
        check_box(method, options = {}, checked_value, unchecked_value) + parent_label(method, nil, {class: 'checkbox m-l-5'})
      end
    end
  end

  # Submit button without colour
  def submit(value = nil, options = {})
    super(value, merge_class(options, 'button'))
  end

  # Submit button with the primary colour for most forms
  def submit_primary(value = nil, options = {})
    submit(value, merge_class(options, 'is-primary'))
  end

  private

  # @param options [Hash]
  # @param value [String]
  def merge_class_attribute_value(options, value)
    new_options = options.clone
    new_options[:class] = [value, new_options[:class]].join(" ")
    new_options
  end

  alias_method :merge_class, :merge_class_attribute_value

  def div_control
    @template.content_tag(:div, class: 'control') do
      yield
    end
  end

  def div_field
    @template.content_tag(:div, class: 'field') do
      yield
    end
  end

  def div_select
    @template.content_tag(:div, class: 'select') do
      yield
    end
  end

  def div_control_for_icons
    @template.content_tag(:div, class: 'control has-icons-left') do
      yield
    end
  end

  def email_icon
    @template.content_tag(:span, class: 'icon is-left') do
      @template.content_tag(:i, "", class: 'fas fa-envelope')
    end
  end

  def password_icon
    @template.content_tag(:span, class: 'icon is-left') do
      @template.content_tag(:i, "", class: 'fas fa-lock')
    end
  end

  def nothing
    ActiveSupport::SafeBuffer.new()
  end

  def identity
    yield if block_given?
  end

  # Errors for method (and for relations without `_id` suffix)
  def errors(method)
    return nothing if object.errors.none?

    methods = [method]
    methods.push(method.to_s.chomp '_id') if method.to_s.end_with? '_id'

    @template.content_tag(:p, class: 'help is-danger') do
      methods.flat_map { |m| object.errors.full_messages_for(m) }.join(', ')
    end
  end

end
