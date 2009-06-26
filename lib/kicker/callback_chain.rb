class Kicker
  class CallbackChain < Array
    alias_method :append_callback,  :push
    alias_method :prepend_callback, :unshift
    
    def call(kicker, files)
      each do |callback|
        files = callback.call(kicker, files)
        break if !files.is_a?(Array) || files.empty?
      end
    end
  end
  
  class << self
    def pre_process_chain
      @pre_process_chain ||= CallbackChain.new
    end
    
    def process_chain
      @process_chain ||= CallbackChain.new
    end
    
    def post_process_chain
      @post_process_chain ||= CallbackChain.new
    end
    
    def pre_process_callback=(callback)
      pre_process_chain.append_callback(callback)
    end
    
    def process_callback=(callback)
      process_chain.append_callback(callback)
    end
    
    def post_process_callback=(callback)
      post_process_chain.prepend_callback(callback)
    end
  end
  
  def pre_process_chain
    self.class.pre_process_chain
  end
  
  def process_chain
    self.class.process_chain
  end
  
  def post_process_chain
    self.class.post_process_chain
  end
end