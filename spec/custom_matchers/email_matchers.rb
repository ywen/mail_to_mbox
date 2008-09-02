module EmailMatchers
  class Have
    def initialize(expected, attribute)
      @expected, @attribute = expected, attribute
    end
    
    def matches?(target)
      addresses = target.send @attribute
      specs = addresses.collect &:spec
      names = addresses.collect &:name
      @target_human_recognizable_addresses = addresses.collect { |address| "#{address.name} <#{address.spec}>" }
      
      return false unless addresses.size == @expected.size      
      @expected.each do |display_name_email|
        return false unless @target_human_recognizable_addresses.include? display_name_email
      end
      true
    end
    
    def failure_message
      "expected '#{@target_human_recognizable_addresses.join("; ")}' to match '#{@expected.join("; ")}'"
    end
    
    def negative_failure_message
      "expected #{@target_human_recognizable_addresses.join("; ")} not match #{@expected.join("; ")}"
    end
  end
  
  def have_recipients expected
    Have.new expected, 'to_addrs'
  end
  
  def have_recipient expected
    Have.new [expected], 'to_addrs'
  end
  
  def have_senders expected
    Have.new expected, 'from_addrs'
  end
  
  def have_sender expected
    Have.new [expected], 'from_addrs'
  end
end