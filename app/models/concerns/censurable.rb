# frozen_string_literal: true

#
# Funcionality related to hiding sensitive information from objects
#
module Censurable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def censors(attribute)
      define_method(:"filtered_#{attribute}") do
        escape_privacy_data(public_send(attribute))
      end
    end
  end

  def escape_privacy_data(text)
    return unless text

    filter_whatsapp(filter_phones(filter_emails(text)))
  end

  def filter_emails(text)
    filter(/([\._a-zA-Z0-9-]+@[\._a-zA-Z0-9-]+)/, text)
  end

  def filter_phones(text)
    filter(/([9|6])+([0-9\s*]{8,})/, text)
  end

  def filter_whatsapp(text)
    filter(/#{whatsapp_slangs.join('|')}/, text)
  end

  private

  def whatsapp_slangs
    %w[
      whatsapp
      whatsupp
      whatsap
      whatsap
      watsap
      guasap
      wuassap
      wuasap
      wassap
      wasap
      guassapp
      guassap
      guasapp
      guasap
      guasp
    ]
  end

  def filter(regexp, text)
    text.gsub(regexp, "[#{privacy_mask}]")
  end

  # @todo Remove gsub when migrating to Ruby 2.4 since Ruby can now do full
  # unicode case mapping.
  def privacy_mask
    I18n.t('nlt.private_info_hidden').upcase.gsub(/ó/, 'Ó').gsub(/é/, 'É')
  end
end
