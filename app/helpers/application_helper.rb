module ApplicationHelper
  def current_url
    request.original_url
  end
end
