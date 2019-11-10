class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  around_action :switch_locale

  private
  def extract_locale_from_accept_language_header
    (request.env['HTTP_ACCEPT_LANGUAGE'] || '').scan(/^[a-z]{2}/).find do |locale|
      I18n.available_locales.include?(locale.to_sym)
    end
  end

  def switch_locale(&action)
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    locale = extract_locale_from_accept_language_header || I18n.default_locale
    logger.debug "* Locale set to '#{locale}'"
    I18n.with_locale(locale, &action)
  end
end
