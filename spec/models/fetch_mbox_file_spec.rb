require File.dirname(__FILE__) + '/../spec_helper'

describe FetchMboxFile, "address" do
  before(:each) do
    @fetch_mbox_file = FetchMboxFile.new("file_id")
  end
  
  it "should find a file under 'public/mboxes' with the same file_id as provided" do
    dir = mock("dir")
    entries = mock("all entries")
    Dir.should_receive(:open).with("#{RAILS_ROOT}/public/mboxes").and_yield(dir)
    dir.should_receive(:entries).and_return(entries)
    entries.should_receive(:find).and_return("a_file")
    @fetch_mbox_file.address.should == "/mboxes/a_file"
  end
end

describe FetchMboxFile::IdMatcher, "match?" do
  before(:each) do
    @matcher = FetchMboxFile::IdMatcher.new("file_id", "file_name")
  end
  
  describe "and obfuscated string of file_name equal to file_id" do
    it "should return true" do
      @matcher.should_receive(:obfuscated_string).and_return("file_id")
      @matcher.should be_match
    end
  end

  describe "and obfuscated string of file_name not equal to file_id" do
    it "should return false" do
      @matcher.should_receive(:obfuscated_string).and_return("another_file_id")
      @matcher.should_not be_match
    end
  end

end