Fog.credentials_path = Rails.root.join('config/fog_credentials.yml')

CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider => 'AWS'
  }
  if Rails.env == 'production'
  	  config.fog_directory = "playersbrand_prod" # required
  	  #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
  	  #config.fog_public     = false                                   # optional, defaults to true
  	  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  else
	  config.fog_directory = "playersbrand_dev" # required
	  #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
	  #config.fog_public     = false                                   # optional, defaults to true
	  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
end