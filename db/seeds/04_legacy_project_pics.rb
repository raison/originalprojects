require 'open-uri'

puts "Seeding images for legacy projects..."

def url_of_legacy_image( filename )
  "http://original-projects.s3.amazonaws.com/legacy/uploads/" + filename
end

(LegacyProjectPic.all + LegacyProjectFile.all).each do |p|
  next unless legacy_project = LegacyProject.find( p.project_id.to_i ) rescue false
  next unless modern_project = Project.find_by_title( legacy_project.title )
  
  #/ 
  # Fetch the image from the S3 legacy depot and attach it to the project
  next unless ( image = LegacyFile.find( p.file_id ) ) rescue false
  next unless image.try( :enc_filename )
  
  print "  ... Processing #{image.enc_filename} for project #{modern_project.title}: "
        
  begin
    open( url_of_legacy_image( image.enc_filename ) ) do |from_s3|
      image_data = from_s3.read
      from_s3.close        

      new_image_file = File.new( image.enc_filename, "w" )
      new_image_file.write( image_data )
      new_image_file.close

      file = File.open( image.enc_filename )
            
      if p.is_a?( LegacyProjectPic ) && modern_project.avatar.blank?
        modern_project.avatar = file
      else
        picture = Image.new
        picture.attachment = file
        modern_project.images << picture
        picture.save!
      end
      
      modern_project.save!
      
      File.unlink( image.enc_filename )
    end
  rescue => e 
    puts e.inspect
    next
  end       
    
  puts "Done."
end
