class SmileGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)  

  def create_initializer_file
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

    template "smileys.rb", "config/initializers/smileys.rb"
  end
end
