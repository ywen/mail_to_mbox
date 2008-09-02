require File.dirname(__FILE__) + '/../spec_helper'

describe MailToMboxesController, "create" do
  describe "with unsuccessful operation" do
    it "should render back new" do
      account = mock("account")
      Account.should_receive(:new).and_return account
      account.should_receive(:connect).and_return false
      post :create
      response.should render_template('new')
    end
  end
  
  describe "with successful operation" do
    attr_reader :account
    before(:each) do
      @account = mock("account", :id => "id")
      Account.stub!(:new).and_return account
      account.stub!(:connect).and_return true
    end
    
    it "should redirect to thanks you page" do
      DownloadLinkMailer.stub!(:deliver_download_link)
      post :create
      response.should redirect_to("/mail_to_mbox/thank_you")
    end
      
  end
  
  
end