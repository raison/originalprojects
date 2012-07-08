module SslBehavior
  def self.included(base)
    base.module_eval do
      before_filter :ensure_proper_protocol
    end
  end

  private

  def ensure_proper_protocol
    if @require_ssl
      if request.protocol != SECURE_PROTO
        redirect_to(:protocol => SECURE_PROTO)
        flash.keep
        return false
      end
    elsif request.protocol != UNSECURE_PROTO
      redirect_to(:protocol => UNSECURE_PROTO)
    end
  end

  def require_https
    @require_ssl = true
  end  
end
