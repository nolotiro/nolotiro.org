class Ad < ActiveRecord::Base
  # legacy database: has a column with value "type", rails doesn't like that
  # the "type" column is no longer need it by rails, so we don't care about it
  self.inheritance_column = nil 

  default_scope { order('date_created DESC') }

end
