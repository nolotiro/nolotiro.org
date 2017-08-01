# frozen_string_literal: true

module PageHelper
  def faq_entry(question, answer, anchor)
    content_tag(:div, class: 'list-group-item') do
      h4 = content_tag(:h4, class: 'list-group-item-heading', id: anchor) do
        question
      end

      p = content_tag(:p, class: 'list-group-item-text') { answer }

      h4 + p
    end
  end
end
