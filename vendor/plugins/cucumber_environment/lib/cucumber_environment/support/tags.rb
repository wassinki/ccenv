# Enables you to do Tag.my_tag to check whether @my_tag is set
class Tags
  class << self
    attr_accessor :tag_expression

    def tags
      @tag_expression.nil? ? [] : @tag_expression.tags
    end
    
    def empty?
      return @tag_expression.empty?
    end
    
    # method missing to perform the tag check on a tag
    def method_missing(sym, *args, &block)    
      return (@tag_expression.nil? || @tag_expression.empty?) ? false : @tag_expression.eval("@#{sym.to_s}")      
    end
  end
end

class Gherkin::TagExpression
    def tags
        @ands.flatten
    end
end

# This one automatically sets the tags
AfterConfiguration do |config|
  Tags.tag_expression = config.tag_expression
end
