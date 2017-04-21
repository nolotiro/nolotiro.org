# frozen_string_literal: true

#
# Place to add common behaviour for all models
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
