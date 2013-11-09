class Ad < ActiveRecord::Base

  belongs_to :user, foreign_key: 'user_owner', :counter_cache => true

  # legacy database: has a column with value "type", rails doesn't like that
  # the "type" column is no longer need it by rails, so we don't care about it
  self.inheritance_column = nil 

  default_scope { order('date_created DESC') }

  has_attached_file :image, :styles => {:thumb => "100x90>"}

  def type_string
    case type
    when 1
      'regalo'
    when 2
      'busco' 
    else
      'regalo'
    end 
  end

  def status_string
    case status
    when 'available'
      'disponible'
    when 'reserved'
      'reservado' 
    when 'delivered'
      'entregado' 
    else
      'disponible'
    end 
  end

end
