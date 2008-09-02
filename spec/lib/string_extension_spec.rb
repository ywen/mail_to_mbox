require File.dirname(__FILE__) + '/../spec_helper'

describe StringExtension, "to_mbox_format" do
  before(:each) do
    @str = %Q/Received: by 10.181.15.12 with HTTP; Mon, 1 Sep 2008 19:35:03 -0700 (PDT)\nFrom: "Test Wen" <test.wen@gmail.com>\nTo: test.wen@gmail.com/
  end
  
  it "should form correct mbox format" do
    @str.to_mbox_format.should == %Q/From "Test Wen" <test.wen@gmail.com>\nReceived: by 10.181.15.12 with HTTP; Mon, 1 Sep 2008 19:35:03 -0700 (PDT)\nTo: test.wen@gmail.com\n/
  end
  
  it "should return self is no From line is found" do
    "mail message".to_mbox_format.should == "mail message"
  end

end