namespace :regen do
  desc "Regenerate all images."
  task :images => :environment do
    print "Processing #{Image.count} images... "
    Image.all.each_with_index do |image, idx|      
      image.attachment = image.attachment
      image.save
      print_count(idx)
    end
  end
  
  desc "Regenerate all avatars."
  task :avatars => :environment do
    print "Processing #{Profile.count} profile avatars... "
    Profile.all.each_with_index do |profile, idx|
      profile.avatar = profile.avatar
      profile.save
      print_count(idx)

    end
    
    print "Processing #{Project.count} project avatars... "
    Project.all.each_with_index do |project, idx|
      project.avatar = project.avatar
      project.save
      print_count(idx)
    end
  end
end

def print_count(idx)
  if idx % 5 == 0
    print " #{idx} "
    STDOUT.flush
  else
    print "."
  end
end