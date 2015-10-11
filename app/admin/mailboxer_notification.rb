ActiveAdmin.register Mailboxer::Notification do
  menu parent: "Mensajería"
  filter :created_at
  index do 
    selectable_column
    actions
  end
end
