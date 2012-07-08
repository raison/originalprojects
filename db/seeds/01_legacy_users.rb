puts "Seeding profiles from legacy users..."

LegacyUser.find_each do |u|
  next if Profile.find(u.id) rescue false
  next if Profile.find_by_username(u.username)

  print "  ... processing #{u.username}: " 
  
  display_name = [u.fname, u.lname].compact.join(" ")
  display_name = u.username if display_name.blank?
  
  profile = Profile.new(
    :city                  => u.city,
    :email                 => u.email,
    :first_name            => u.fname,
    :display_name          => display_name,
    :last_name             => u.lname,
    :password              => 'temporary', 
    :password_confirmation => 'temporary', 
    :city                  => ( ( u.city.nil? || u.city.blank? ) ? 'Not specified' : u.city ),
    :state                 => u.state,
    :tos_accepted          => 'Y',
    :url                   => u.website,
    :username              => u.username )
    
  unless profile.save! 
    puts " Skipping."
    next
  end
  
  #/
  # Put the legacy SHA1 password back in place now that the user
  #   has been validated and saved. 
  profile.password_salt = 'nil'
  profile.password_hash = u.password
  profile.save
  
  puts "Done."
end
