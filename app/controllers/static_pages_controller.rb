class StaticPagesController < ApplicationController
  
  def home
  end

  def guidelines
  end

  def faq
  end

  def contact
  end

  def empty_site
    flash[:warning] = "The requested page is still in progress."
    redirect_to root_url
  end
end
