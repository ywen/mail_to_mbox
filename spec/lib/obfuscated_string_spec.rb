require File.dirname(__FILE__) + '/../spec_helper'

describe ObfuscatedString, "generating obfuscated string method" do
  
  it "should be concatenation of hashes of two components of start_string_method" do
    test_obj = Class.new() do 
      extend ObfuscatedString; 
      generate_obfuscated_string_method :method_name, :test_string
  
      def test_string
        "test_20098976"
      end
      
    end.new
  
    test_obj.method_name.should == "#{'test'.hash.abs}#{'20098976'.hash.abs}"
  end
end
  