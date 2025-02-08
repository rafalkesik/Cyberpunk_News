module CustomDeviseHelper
  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || user_path(current_user)
  end
end
