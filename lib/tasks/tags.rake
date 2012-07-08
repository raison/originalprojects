module Tags
  RUBY_FILES = FileList['**/*.rb'].exclude("pkg")
end

namespace "tags" do
  desc 'create tags for emacs'
  task :emacs => Tags::RUBY_FILES do
    puts "Making Emacs TAGS file"
    sh "ctags -e #{Tags::RUBY_FILES}", :verbose => false
  end
end

task :tags => ["tags:emacs"]
