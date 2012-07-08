require 'yaml'

s3_configuration = YAML.load_file( File.join( RAILS_ROOT, %W( config s3.yml ) ) )
s3 = s3_configuration[ RAILS_ENV || 'development' ]

if Rails.env == :production
  CarrierWave.configure do |config|
    config.storage              = :s3
    config.s3_access_key_id     = s3[ 'access_key_id' ]
    config.s3_secret_access_key = s3[ 'secret_access_key' ]
    config.s3_bucket            = s3[ 'bucket' ]
    config.s3_access            = :public_read
  end
end