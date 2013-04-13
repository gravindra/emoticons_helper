class SmileGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)  

  def create_initializer_file
    str = %!#This file loads simileys
module SmileyHelpers
  def replace_smilies(str, animate=false)
    smilies = YAML.load_file("\#{Rails.root}/config/smilies.yml")
    smilies.each_pair do |k, v|
      if animate
        new_str = "<span class=\'smilies animate"+k+"\'>&nbsp;</span>"
      else
        new_str = "<span class=\'smilies "+k+"\'>&nbsp;</span>"
      end
      v.each{|val| str = str.gsub(val, new_str)}
    end
    str.html_safe
  end
end
ActionView::Base.send :include, SmileyHelpers
    !

    copy_file "smilies.yml", "#{Rails.root}/config/smilies.yml"

    if Dir.exists?("#{Rails.root}/app/assets/")
      FileUtils.mkpath("#{Rails.root}/app/assets/images/smilies")
      files = Dir.glob("#{File.expand_path('../templates/smilies', __FILE__)}/*")
      FileUtils.cp_r files, "#{Rails.root}/app/assets/images/smilies/"
      copy_file "smilies.css", "#{Rails.root}/app/assets/stylesheets/smilies.css"
    else
      FileUtils.mkpath("#{Rails.root}/public/images/smilies")
      files = Dir.glob("#{File.expand_path('../templates/smilies', __FILE__)}/*")
      FileUtils.cp_r files, "#{Rails.root}/public/images/smilies/"
      copy_file "smilies.css", "#{Rails.root}/public/stylesheets/smilies.css"
    end

    create_file "config/initializers/smileys.rb", str
  end
end
