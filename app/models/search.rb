class Search
  attr_reader :query

  def initialize(options)
    @query = options[:q]

    search_opts = {
      :page     => options[:page] || 1,
      :per_page => options[:n] || 10
    }

    @results = @query.blank? ? [] : ThinkingSphinx.search(@query, search_opts)
    @results.reject! { |result|
      result.respond_to?(:public) && !result.public
    }
  end


  def method_missing(method, *args, &block)
    @results.send(method, *args, &block)
  end
end
