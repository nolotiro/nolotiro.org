# frozen_string_literal: true
AdminPolicy = Struct.new(:user, :admin) do
  def lock?
    user && user.admin?
  end

  def unlock?
    user && user.admin?
  end

  def become?
    user && user.admin?
  end
end
