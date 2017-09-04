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
    filter(/(wh?ats[au]pp?|wu?ass?ap|guass?app?|guasp)/, text)
  end

  private

  def filter(regexp, text)
    text.gsub(regexp, "[#{privacy_mask}]")
  end

  def privacy_mask
    I18n.t('nlt.private_info_hidden').upcase
  end
end
