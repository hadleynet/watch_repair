module InvoicesHelper
  def format_text(s)
    s ||= ""
    s.split(". ").collect {|s| s.downcase.capitalize}.join(". ")
  end

  def format_id(s)
    s ||= ""
    s.upcase
  end
end
