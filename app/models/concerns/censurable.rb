# frozen_string_literal: true

#
# Funcionality related to hiding sensitive information from objects
#
module Censurable
  def escape_privacy_data(text)
    return unless text

    text = text.gsub(/([\._a-zA-Z0-9-]+@[\._a-zA-Z0-9-]+)/, ' ')
    text = text.gsub(/([9|6])+([0-9\s*]{8,})/, ' ')
    text = text.gsub(/whatsapp/, ' ')
    text = text.gsub(/whatsupp/, ' ')
    text = text.gsub(/whatsap/, ' ')
    text = text.gsub(/whatsap/, ' ')
    text = text.gsub(/watsap/, ' ')
    text = text.gsub(/guasap/, ' ')
    text = text.gsub(/wuassap/, ' ')
    text = text.gsub(/wuasap/, ' ')
    text = text.gsub(/wassap/, ' ')
    text = text.gsub(/wasap/, ' ')
    text = text.gsub(/guassapp/, ' ')
    text = text.gsub(/guassap/, ' ')
    text = text.gsub(/guasapp/, ' ')
    text = text.gsub(/guasap/, ' ')
    text = text.gsub(/guasp/, ' ')
    text
  end
end
