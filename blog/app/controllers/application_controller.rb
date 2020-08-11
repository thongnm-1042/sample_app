class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    parsed_locale if I18n.available_locales.map(&:to_s).include? parsed_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
