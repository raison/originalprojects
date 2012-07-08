require 'open-uri'

puts "Seeding images for legacy users..."

def url_of_legacy_image( filename )
  "http://original-projects.s3.amazonaws.com/legacy/uploads/" + filename
end

LegacyUser.find_each do |legacy_user|
  next unless modern_user = Profile.find_by_username( legacy_user.username )
  
  #/ 
  # Fetch the user's images from the S3 legacy depot and attach them
  #   to the user. 
  LegacyUserPic.find_all_by_user_id( legacy_user.id.to_s ).each do |p|
    next unless image = LegacyFile.find( p.file_id ) rescue false

    print "  ... Processing #{image.enc_filename} for user #{modern_user.username}: "
        
    begin
      open( url_of_legacy_image( image.enc_filename ) ) do |from_s3|
        image_data = from_s3.read
        from_s3.close        

        new_image_file = File.new( image.enc_filename, "w" )
        new_image_file.write( image_data )
        new_image_file.close

        modern_user.avatar = File.open ( image.enc_filename )        
        modern_user.save!
        
        File.unlink( image.enc_filename )
      end
    rescue => e 
      puts e.inspect
      next
    end       
    
    puts "Done."
  end
end

