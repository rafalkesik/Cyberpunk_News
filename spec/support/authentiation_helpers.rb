module AuthenticationHelpers
  def login_as(user)
    post login_path, params: { user: { username: user.username,
                                       password: 'pass' } }
  end

  def logout
    session[:user_id] = nil
  end

  def logged_in?
    !!session[:user_id]
  end
end
