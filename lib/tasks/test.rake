namespace :test do
 
  desc 'Measures test coverage'
  task :coverage do
    rm_f "coverage"
    rm_f "coverage.data"
    rcov = "rcov -Itest --rails --aggregate coverage.data -T -x \" rubygems/*,/Library/Ruby/Site/*,gems/*,rcov*\""
    system("#{rcov} --no-html test/unit/*_test.rb")
    system("#{rcov} --no-html test/unit/helpers/*_test.rb") unless Dir['test/unit/helpers/*_test.rb'].empty?
    system("#{rcov} --no-html test/functional/*_test.rb")
    system("#{rcov} --no-html test/integration/*_test.rb") unless Dir['test/integration/*_test.rb'].empty?
    system("#{rcov} --html")
    system("open coverage/index.html") if PLATFORM['darwin']
  end
 
end
