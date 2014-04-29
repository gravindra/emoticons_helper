#This file loads simileys
module SmileyHelpers
  def self.regex
    return @regex if defined?(@regex)

    before_and_after_with_space = "[.,;:!\\?\\(\\[\\{\\)\\]\\}\\-]|\\s"
    before_and_after_without_space = "[.,;:!\\?\\(\\[\\{\\)\\]\\}\\-]|"
    @regex = Regexp.compile("(^|#{before_and_after_with_space})(" +
            smilies.keys.map { |token| Regexp.union(token) }.join("|") +
            ")($|#{before_and_after_without_space})", Regexp::MULTILINE|Regexp::IGNORECASE|Regexp::EXTENDED)
  end

  def self.smilies
    return @smilies unless @smilies.nil?

    @smilies = {}
    
    YAML.load_file("#{Rails.root}/config/smilies.yml").each do |smiley_name, symbols|
      symbols.each{|s| @smilies[s] = smiley_name }
    end

    @smilies
  end

  def self.replace_smilies(str, animate=false)
    str = str.to_str
    str = str.gsub(self.regex) do
      if animate
        %(#{$1}<span class="smilies animate#{self.smilies[$2]}" title="#{$2}">&nbsp;</span>#{$3})
      else
        %(#{$1}<span class="smilies #{self.smilies[$2]}" title="#{$2}">&nbsp;</span>#{$3})
      end
    end

    str.respond_to?(:html_safe) ? str.html_safe : str
  end

  def replace_smilies(str, animate=false)
    # Just call class method.
    SmileyHelpers.replace_smilies(str, animate)
  end
end

ActionView::Base.send :include, SmileyHelpers    
