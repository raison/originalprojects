require File.join( RAILS_ROOT, 'lib', 'legacy', 'yamldb.rb' )

puts "Seeding raw legacy data..."

YamlDb.load( File.join( RAILS_ROOT, 'db/migrate/data/legacy_data.yml' ) )
