require File.dirname(__FILE__) + '/../spec_helper'

describe MailWritter, "write" do
    before(:each) do
        @account = ObjectMother.build :account
        @mail1 = stub("mail", :pop => "mail1 message")
        @mails = stub("mails")
        @account.stub!(:start_connection).and_yield(@mails)
        @mail_writter = MailWritter.new(@account)
    end

    it "should write to file provided by the caller" do
        File.should_receive(:open).with("#{RAILS_ROOT}/public/mboxes/#{@account.file_name}", "w")
        @mail_writter.write
    end

    it "should write all emails" do
        f = mock("file")
        File.should_receive(:open).and_yield(f)
        @mails.should_receive(:each_mail).and_yield(@mail1)
        f.should_receive(:write).with("mail1 message")
        @mail_writter.write
    end

    it "should send the email" do
        @account.stub!(:start_connection)        
       DownloadLinkMailer.should_receive(:deliver_download_link).with(@account)
       @mail_writter.write
     end

end