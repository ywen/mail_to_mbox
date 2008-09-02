require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../custom_matchers/email_matchers'

describe DownloadLinkMailer, "download link" do
  include EmailMatchers
  
  before(:each) do
    @account = stub("account", :email_address => "email@example.com", :id => "id")
    @mail = DownloadLinkMailer.create_download_link(@account)
  end
  
  it "should set the subject" do
    @mail.subject.should == "Your email archive download link"
  end
  
  it "should set the body_text" do
    @mail.body.should == "Your email has been archived. you can download you email archive in mbox form at http://getmyemails.selfip.com:3000/download/id"
  end
  it "should set the recipients" do
    @mail.should have_recipient(" <email@example.com>")
  end
  
  it "should set the from" do
    @mail.should have_sender(" <no-reply@example.com>")
  end
end