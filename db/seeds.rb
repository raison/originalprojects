Dir.glob(File.join( RAILS_ROOT, 'db', 'seeds', '**', '*.rb')).sort.each { | rb | load rb }
