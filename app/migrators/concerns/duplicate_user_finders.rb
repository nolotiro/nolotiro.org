#
# Some scopes for finding duplications in the users table
#
module DuplicateUserFinders
  def duplicated_emails
    group('lower(email)').having('count(*) > 1').pluck('lower(email)')
  end

  def duplicates_for(email)
    where("lower(email) = '#{email}'")
  end
end
