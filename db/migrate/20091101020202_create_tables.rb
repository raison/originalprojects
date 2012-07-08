class CreateTables < ActiveRecord::Migration
  def self.up
    #------------------------------------------------------------
    # ActiveRecord Sessions
    #------------------------------------------------------------
    create_table :sessions, :force => true do |t|
      t.text     :data
      t.string   :session_id
      t.datetime :updated_at
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at

    #------------------------------------------------------------
    # Profile
    #------------------------------------------------------------
    create_table :profiles, :force => true do |t|
      t.timestamps

      len = Profile::ATTR_LENGTHS

      t.boolean  :active, :default => true, :null => false
      t.string   :username,      :limit => len[:username],      :null => false, :unique => true
      t.string   :password_hash, :limit => len[:password_hash], :null => false
      t.string   :password_salt, :limit => len[:password_salt], :null => false
      t.string   :first_name,    :limit => len[:first_name]
      t.string   :last_name,     :limit => len[:last_name]
      t.string   :display_name,  :limit => len[:display_name]
      t.string   :email,         :limit => len[:email], :unique => true
      t.string   :url,           :limit => len[:email]
      
      t.string   :city,          :limit => len[:city]
      t.string   :country,       :limit => len[:country]
      t.string   :state,         :limit => len[:state]
      t.string   :phone_home,    :limit => len[:phone_home]
      t.string   :phone_mobile,  :limit => len[:phone_mobile]
      t.string   :phone_office,  :limit => len[:phone_office]
      t.string   :zip,           :limit => len[:zip]

      t.string   :email_verification, :limit => len[:email_verification]
      t.boolean  :email_verified

      t.string   :remember_token, :limit => len[:remember_token]
      t.datetime :remember_token_expires_at

      t.string   :persistence_token, :null => false
    end

    #------------------------------------------------------------
    # Project
    #------------------------------------------------------------
    create_table :projects, :force => true do |t|
      t.timestamps

      len = Project::ATTR_LENGTHS

      t.boolean    :active, :null => false, :default => true
      t.boolean    :public, :default => true
      t.string     :membership_status, :limit => len[:membership_status]
      t.string     :title, :limit => len[:title], :null => false
      t.text       :description
      t.text       :goals
      t.text       :current_resources
      t.text       :resources_needed
    end

    #------------------------------------------------------------
    # ProfileProject
    #------------------------------------------------------------
    create_table :profile_projects, :force => true do |t|
      t.timestamps

      t.references :profile, :null => false, :foreign_key => true
      t.references :project, :null => false, :foreign_key => true
      t.string     :role,    :null => false
    end

    add_index(:profile_projects, [:profile_id, :project_id, :role], :unique => true)

    #------------------------------------------------------------
    # InvitationToken
    #------------------------------------------------------------
    create_table :invitation_tokens, :force => true do |t|
      t.timestamps
      t.boolean :used, :default => false
      t.string :token, :null => false, :unique => true
    end

    #------------------------------------------------------------
    # Message
    #------------------------------------------------------------
    create_table :messages, :force => true do |t|
      t.timestamps

      t.belongs_to  :from
      t.belongs_to  :to
      t.string      :subject
      t.text        :body
    end

    add_foreign_key :messages, :profiles, :column => 'from_id'
    add_foreign_key :messages, :profiles, :column => 'to_id'

    add_index :messages, :from_id
    add_index :messages, :to_id

  end

  def self.down
    drop_table :messages
    drop_table :invitation_tokens
    drop_table :profile_projects
    drop_table :projects
    drop_table :profiles
    drop_table :sessions
  end
end
