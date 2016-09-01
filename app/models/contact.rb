# frozen_string_literal: true

class Contact
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :email, :message

  validates :email, presence: true
  validates :message, presence: true

  validates :email, format: { with: /@/ }
  validates :message, length: { maximum: 2000 }
  validates :message, length: { minimum: 50 }

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
