# Enables you to do Tag.my_tag to check whether @my_tag is set
class Tags
  class << self
    attr_accessor :tag_expression
    
    def empty?
      return @tag_expression.empty?
    end
    
    # method missing to perform the tag check on a tag
    def method_missing(sym, *args, &block)    
      return @tag_expression.nil? ? false : @tag_expression.eval("@#{sym.to_s}")      
    end
  end
end

# This one automatically sets the tags
AfterConfiguration do |config|
  Tags.tag_expression = config.tag_expression
end
