module TextHelper
  def format_text(input)
    input.gsub("\r\n", "<br>").gsub("\n", "<br>").html_safe
  end
end