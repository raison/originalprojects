class CreateLegacy < ActiveRecord::Migration
  def self.up
    create_table :legacy_files, :force => true do |t|
      t.integer :owner,         :limit => 8,   :null => false
      t.string  :filename,                     :null => false
      t.string  :enc_filename,                 :null => false
      t.string  :file_type,     :limit => 50,  :null => false
      t.integer :file_size,     :limit => 8,   :null => false
      t.string  :date_uploaded, :limit => 50,  :null => false
      t.string  :caption,       :limit => 600
      t.string  :ext,           :limit => 6,   :null => false
    end

    create_table :legacy_project_files, :id => false, :force => true do |t|
      t.string :project_id, :limit => 99, :null => false
      t.string :file_id,    :limit => 99, :null => false
    end

    create_table :legacy_project_pics, :id => false, :force => true do |t|
      t.string :project_id, :limit => 9, :null => false
      t.string :file_id,    :limit => 9, :null => false
    end

    create_table :legacy_projects, :force => true do |t|
      t.text    :title
      t.text    :urltitle,                   :null => false
      t.string  :owner,       :limit => 300, :null => false
      t.string  :address,     :limit => 300, :null => false
      t.string  :city,        :limit => 300, :null => false
      t.string  :state,       :limit => 300, :null => false
      t.string  :zip,         :limit => 5,   :null => false
      t.text    :needs
      t.string  :date,        :limit => 20,  :null => false
      t.boolean :ispublished,                :null => false
      t.string  :status,      :limit => 300, :null => false
      t.text    :description
      t.text    :haves
      t.text    :team
      t.integer :likes
    end

    create_table :legacy_user_pics, :id => false, :force => true do |t|
      t.string :user_id, :limit => 6, :null => false
      t.string :file_id, :limit => 6, :null => false
    end

    create_table :legacy_users, :force => true do |t|
      t.string  :username,                          :null => false
      t.string  :urlusername,                       :null => false
      t.string  :email,                             :null => false
      t.string  :password,                          :null => false
      t.string  :fname,                             :null => false
      t.string  :lname,                             :null => false
      t.string  :address,                           :null => false
      t.string  :city,                              :null => false
      t.string  :state,       :limit => 30,         :null => false
      t.string  :zipcode,     :limit => 15,         :null => false
      t.string  :phone,                             :null => false
      t.text    :services,                          :null => false
      t.string  :website,                           :null => false
      t.string  :last_logon,  :limit => 200,        :null => false
      t.boolean :user_type,                         :null => false
      t.boolean :termsagree,                        :null => false
    end
  end

  def self.down
    drop_table :legacy_projects
    drop_table :legacy_project_pics
    drop_table :legacy_project_files
    drop_table :legacy_files
  end
end
