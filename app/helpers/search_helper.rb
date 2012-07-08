module SearchHelper
  def result_partial(result)
    type = result.class.to_s.downcase
    render :partial => type, :locals => { type.to_sym => result }
  end
end