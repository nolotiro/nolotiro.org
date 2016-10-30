# frozen_string_literal: true

module FaqHelper
  def faqentry(question, answer)
    content_tag(:strong) { "* #{question}" } +
      tag(:br) +
      answer +
      tag(:br) +
      tag(:br)
  end
end
