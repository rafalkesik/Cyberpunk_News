module LanguageHelper
  
  LANGUAGES = {
    'en' => ['gb', 'English'],
    'pl' => ['pl', 'Polish']
  }
  
  def flag(locale)
    content_tag(:img, '',
        src: "https://flagcdn.com/28x21/#{LANGUAGES["#{locale}"][0]}.png",
        srcset: "https://flagcdn.com/56x42/#{LANGUAGES["#{locale}"][0]}.png 2x,
                https://flagcdn.com/84x63/#{LANGUAGES["#{locale}"][0]}.png 3x",
        width: "28",
        height: "21",
        alt: "#{LANGUAGES["#{locale}"][1]}")
  end

  def language_selector
    links = []
    I18n.available_locales.each do |locale|
      link = link_to flag("#{locale}"),
                      params.permit(:locale).merge(:locale => locale)
      links << content_tag(:li, link)
    end
    links.join.html_safe
  end

end
