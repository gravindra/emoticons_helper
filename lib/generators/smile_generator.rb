class SmileGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)  

  def create_initializer_file
    str = %!#This file loads simileys
module SmileyHelpers
  def replace_smilies(str)
    smilies = YAML.load_file("\#{Rails.root}/config/smilies.yml")
    smilies.each_pair do |k, v|
      new_str = "<span class=\\'smilies "+k+"\\'>&nbsp;</span>"
      v.each{|val| str = str.gsub(val, new_str)}
    end
    str.html_safe
  end
end
ActionView::Base.send :include, SmileyHelpers
    !

    copy_file "smilies.yml", "#{Rails.root}/config/smilies.yml"

    if Dir.exists?("#{Rails.root}/app/assets/")
      copy_file "smilies-sprite.png", "#{Rails.root}/app/assets/images/smilies-sprite.png"
      copy_file "smilies.css", "#{Rails.root}/app/assets/stylesheets/smilies.css"
    else
      copy_file "smilies-sprite.png", "#{Rails.root}/public/images/smilies-sprite.png"
      copy_file "smilies.css", "#{Rails.root}/public/stylesheets/smilies.css"
    end

    create_file "config/initializers/smileys.rb", str
  end
end
