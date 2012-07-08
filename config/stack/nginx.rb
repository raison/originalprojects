package :nginx_passenger, :provides => [:webserver, :appserver] do
  description "Nginx with the Passenger module"
  version "0.7.64"
  install_path "/usr/local/nginx"
  
  source "http://sysoev.ru/nginx/nginx-#{version}.tar.gz" do
    custom_install "sudo /usr/local/bin/passenger-install-nginx-module " +
      "--auto --prefix=#{install_path} --nginx-source-dir=/usr/local/build/nginx-#{version} " +
      "--extra-configure-flags='--with-http_ssl_module'"
    post :install, "sudo ln -s #{install_path}/sbin/nginx /usr/local/bin/nginx"
  end
  
  verify do
    has_directory "/usr/local/nginx"
    has_file "/usr/local/nginx/conf/nginx.conf"
    has_executable "/usr/local/nginx/sbin/nginx"
  end
  
  requires :ruby_enterprise, :build_essential
end

package :nginx_init do
  description "Nginx init.d file for Ubuntu"
  version "v2.0.0-RC2"
  install_path "/etc/init.d"
  
  transfer 'config/stack/files/nginx-init.sh', '/tmp/nginx' do
    post :install, "sudo mv /tmp/nginx /etc/init.d/nginx"
    post :install, "sudo /usr/sbin/update-rc.d -f nginx defaults"
  end
  
  verify do
    has_file "/etc/init.d/nginx"
  end
end