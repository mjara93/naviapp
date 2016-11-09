Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += Dir.glob(File.join(Rails.root.to_path,'app/assets/javascripts/*.j*')).map{|f| File.basename(f).split('.')[0..1].join('.')}

Rails.application.config.assets.precompile += Dir.glob(File.join(Rails.root.to_path,'app/assets/stylesheets/*.c*')).map{|f| File.basename(f).split('.')[0..1].join('.')}

Rails.application.config.assets.debug = ENV['RAILS_ENV'] and ENV['RAILS_ENV'].include? 'development'
