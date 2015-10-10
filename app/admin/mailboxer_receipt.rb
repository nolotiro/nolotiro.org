ActiveAdmin.register Mailboxer::Receipt do
  filter :created_at
 
  index do 
    selectable_column
    actions
  end
end
