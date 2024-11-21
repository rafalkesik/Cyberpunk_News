class StaticPagesController < ApplicationController
  include ApplicationHelper

  def home
    @user = current_user
  end

  def guidelines
    @user = current_user
  end

  def faq
    @user = current_user
  end

  def contact
    @user = current_user
  end

  def empty_site
    flash[:warning] = "The requested page is still in progress."
    redirect_to root_url
  end

  def empty_functionality
    flash[:warning] = "Upvote functionality is still in progress."
    redirect_to posts_url, status: :see_other
  end
end
