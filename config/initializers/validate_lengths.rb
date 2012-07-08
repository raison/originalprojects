class ActiveRecord::Base
  def self.opw_validate_lengths attr_lengths_hash
    attr_lengths_hash.each {|key,value|
      validates_length_of(key, { :maximum => value, :allow_blank => true, :allow_nil => true })
    }
  end
end
