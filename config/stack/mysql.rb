package :mysql, :provides => :database do
  description 'MySQL Database'
  apt %w( mysql-server mysql-client libmysqlclient15-dev ) do
    post :install do 
      [ %Q{mysql -u root -e "GRANT ALL ON *.* TO 'opw'@'localhost' IDENTIFIED BY 'opigtloD12'"},
        %Q{mysqladmin -u root password 'TiaVHp2rem'} ]
    end
  end
  
  verify do
    has_executable 'mysql'
  end
end
 
package :mysql_driver, :provides => :ruby_database_driver do
  description 'Ruby MySQL database driver'
  gem 'mysql'
  
  verify do
    has_gem 'mysql'
  end
  
  requires :mysql, :ruby_enterprise
end
