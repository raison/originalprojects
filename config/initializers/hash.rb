class Hash
  # Return copy of this Hash with any key not in arr removed.
  def select_keys arr
    self.reject {|key,value| !arr.include?(key) }
  end
end
