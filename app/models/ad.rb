# encoding : utf-8
class Ad < ActiveRecord::Base

  require 'ipaddress'

  belongs_to :user, foreign_key: 'user_owner', :counter_cache => true
  has_many :comments, class_name: 'Comment', foreign_key: 'ads_id'

  validates :title, presence: true
  validates :body, presence: true
  validates :user_owner, presence: true
  validates :woeid_code, presence: true
  validates :ip, presence: true

  validates :title, length: {minimum: 10, maximum: 100}
  validates :body, length: {minimum: 30, maximum: 65000}

  validates :status,
    inclusion: { in: [1, 2, 3], message: "no es un estado válido" },
    presence: true

  validates :type,
    inclusion: { in: [1, 2], message: "no es un tipo válido" },
    presence: true

  #validate :valid_ip_address

  # legacy database: has a column with value "type", rails doesn't like that
  # the "type" column is no longer need it by rails, so we don't care about it
  self.inheritance_column = nil 

  default_scope { order('ads.created_at DESC') }

  acts_as_paranoid

  has_attached_file :image,
    styles: {thumb: "100x90>"},
    process_in_background: :image 

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  validates_attachment_size :image, :in => 0.megabytes..1.megabytes

  scope :give, -> { where(type: 1) }
  scope :want, -> { where(type: 2) }

  scope :by_type, lambda {|type|
    return scope unless type.present?
    where('type = ?', type) 
  }

  scope :available, -> { where(status: 1) }
  scope :booked, -> { where(status: 2) }
  scope :delivered, -> { where(status: 3) }

  scope :by_status, lambda {|status|
    return all unless status.present?
    where('status = ?', status) 
  }

  scope :by_woeid_code, lambda {|woeid_code|
    return all unless woeid_code.present?
    where('woeid_code = ?', woeid_code) 
  }

  def body 
    ApplicationController.helpers.escape_privacy_data(read_attribute(:body))
  end

  def title 
    ApplicationController.helpers.escape_privacy_data(read_attribute(:title))
  end

  def readed_counter
    readed_count || 1
  end

  def increment_readed_count!
    # Is this premature optimization?
    # AdIncrementReadedCountWorker.new(self.id)
    Ad.increment_counter(:readed_count, self.id)
  end

  def slug
    title.parameterize
  end

  def woeid_name
    WoeidHelper.convert_woeid_name(self.woeid_code)
  end

  def full_title 
    self.type_string + " segunda mano " + self.title + ' ' + self.woeid_name
  end

  def type_string
    case type
    when 1
      I18n.t('nlt.give')
    when 2
      I18n.t('nlt.want')
    else
      I18n.t('nlt.give')
    end 
  end

  def type_class
    case type
    when 1
      "give"
    when 2
      "want"
    else
      "give"
    end 
  end

  def status_class
    case status
    when 1
      'available'
    when 2
      'booked' 
    when 3
      'delivered' 
    else
      'available'
    end 
  end

  def status_string
    case status
    when 1
      I18n.t('nlt.available')
    when 2
      I18n.t('nlt.booked') 
    when 3
      I18n.t('nlt.delivered') 
    else
      I18n.t('nlt.available')
    end 
  end

  def valid_ip_address
    unless IPAddress.valid?(ip)
      errors.add(:ip, "No es una IP válida")
    end
  end

  def is_give? 
    type == 1
  end

  def is_want? 
    type == 2
  end

  def meta_title
    "#{I18n.t('nlt.keywords')} #{self.title} #{self.woeid_name}"
  end

end
