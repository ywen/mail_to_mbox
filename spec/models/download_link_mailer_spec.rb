require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../custom_matchers/email_matchers'

describe DownloadLinkMailer, "download link" do
  include EmailMatchers
  
  before(:each) do
    @account = stub("account", :email_address => "email@example.com", :id => "id")
    ENV['MAIL_TO_MBOX_BASE_HOST'] = nil
    @mail = DownloadLinkMailer.create_download_link(@account)
  end
  
  it "should set the subject" do
    @mail.subject.should == "Your email archive download link"
  end
  
  describe "body text" do
    it "should set base host to localhost:3000 with the environment" do
      @mail.body.should == "Your email has been archived. you can download you email archive in mbox form at http://localhost:3000/download/id"
    end

    it "should set base host to ENV['MAIL_TO_MBOX_BASE_HOST'] with the environment" do
      ENV['MAIL_TO_MBOX_BASE_HOST'] = "http://a_new_address"
      @mail = DownloadLinkMailer.create_download_link(@account)
      @mail.body.should == "Your email has been archived. you can download you email archive in mbox form at http://a_new_address/download/id"
    end

  end
  
  it "should set the recipients" do
    @mail.should have_recipient(" <email@example.com>")
  end
  
  it "should set the from" do
    @mail.should have_sender(" <no-reply@example.com>")
  end
end