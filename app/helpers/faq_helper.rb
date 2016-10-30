# frozen_string_literal: true

module FaqHelper
  def faqentry(question, answer)
    content_tag(:div, class: 'list-group-item') do
      h4 = content_tag(:h4, class: 'list-group-item-heading') { question }

      p = content_tag(:p, class: 'list-group-item-text') { answer }

      h4 + p
    end
  end
end
