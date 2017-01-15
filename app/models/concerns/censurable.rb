# frozen_string_literal: true

#
# Funcionality related to hiding sensitive information from objects
#
module Censurable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def censors(attribute, options = {})
      define_method(:"filtered_#{attribute}") do
        escape_privacy_data(public_send(attribute))
      end

      define_method(:"min_filtered_#{attribute}") do
        value = public_send(:"filtered_#{attribute}")

        if value.blank?
          errors.add(attribute, :blank) if options[:presence]
        elsif options[:min_length] && value.length < options[:min_length]
          errors.add(attribute, :too_short, count: value.length)
        end
      end

      class_eval do
        validate :"min_filtered_#{attribute}"
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
    %w(
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
    )
  end

  def filter(regexp, text)
    text.gsub(regexp, ' ')
  end
end
