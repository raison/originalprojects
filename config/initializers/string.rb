class String
  def to_slug
    self.strip.downcase.gsub(/[^\w]+/, '-')
  end
end
