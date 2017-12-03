# frozen_string_literal: true

module Antifraud
  class Match < ApplicationRecord
    belongs_to :antifraud_rule, class_name: 'Antifraud::Rule', inverse_of: :matches
    belongs_to :ad
  end
end
