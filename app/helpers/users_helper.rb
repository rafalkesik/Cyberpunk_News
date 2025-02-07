module UsersHelper
  def can_delete_user(user)
    current_user&.admin == true && user.admin == false
  end
end
