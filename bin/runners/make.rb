p = Project.new
p.title = "Project X"
p.description = "Secret project."
p.membership_status = "open"

i = Image.new
i.attachment = File.open("test.jpg")
# i.save
p.images << i
p.save!
puts "Done"