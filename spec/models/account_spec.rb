require File.dirname(__FILE__) + '/../spec_helper'

describe Account, "vaidations" do
    attr_reader :account
    before(:each) do
        @account = ObjectMother.build :account
        account.stub!(:start_connection)
    end

    it "should have a valid state" do
        account.should be_valid
    end

    it "should be invalid without email address" do
        account.email_address=nil
        account.should_not be_valid
        account.errors.on(:email_address).should_not be_nil
    end

    it "should be invalid without username" do
        account.username=nil
        account.should_not be_valid
        account.errors.on(:username).should_not be_nil
    end

    it "should be invalid without password" do
        account.password=nil
        account.should_not be_valid
        account.errors.on(:password).should_not be_nil
    end

    it "should be invalid without server" do
        account.server=nil
        account.should_not be_valid
        account.errors.on(:server).should_not be_nil
    end

    it "should be invalid without port" do
        account.port=nil
        account.should_not be_valid
        account.errors.on(:port).should_not be_nil
    end

    it "should be invalid with a non-numeric port" do
        account.port="ww"
        account.should_not be_valid
        account.errors.on(:port).should_not be_nil
    end

    it "should be invalid with wrong params" do
        account.stub!(:start_connection).and_raise(Exception.new("error message"))
        account.should_not be_valid
        account.errors.on(:base).should == "error message"
    end

end

describe Account, "new" do
    attr_reader :params
    before(:each) do
        @params = {:email_address => "email address", :server => "server",
                :username => "username", :password => "password", :ssl => "0", :port => "port"}

    end

    it "should assign values from params" do
        account = Account.new(params)
        account.email_address.should == params[:email_address]
        account.server.should == params[:server]
        account.username.should == params[:username]
        account.password.should == params[:password]
        account.port.should == params[:port]
    end
end

describe Account, "ssl?" do
    it "should return true with ssl == '1'" do
        Account.new(:ssl => "1").should be_ssl
    end
    it "should return false with blank ssl" do
        Account.new.should_not be_ssl
    end
    it "should return true with ssl be anything other than '1'" do
        Account.new(:ssl => "0").should_not be_ssl
    end
end

describe Account, "start connection" do
    describe "and block is given" do
        it "should yield the block" do
            account = ObjectMother.build :account
            Net::POP3.stub!(:enable_ssl)
            Net::POP3.should_receive(:start).and_yield("pop")
            account.start_connection {|pop| pop}.should == "pop"
        end
    end

    describe "and ssl is true" do
        it "should enable ssl" do
            account = ObjectMother.build :account, :ssl => "1"
            Net::POP3.should_receive(:enable_ssl).with(OpenSSL::SSL::VERIFY_NONE)
            Net::POP3.stub!(:start)
            account.start_connection
        end
    end

    describe "and ssl is false" do
        it "should not enable ssl" do
            account = ObjectMother.build :account, :ssl => "0"
            Net::POP3.should_not_receive(:enable_ssl)
            Net::POP3.stub!(:start)
            account.start_connection
        end
    end

end

describe Account, "file name" do
    before(:each) do
        @time = 1.minute.ago
        Time.stub!(:now).and_return(@time)
        @account = Account.new(:email_address=>"user@gmail.com")
    end
    it "should generate a file name based on the username and timestamp" do
        @account.file_name.should == "useratgmail.com_#{@time.strftime('%Y%m%d%H%M%S')}"
    end

    it "should cache it" do
        @account.file_name
        Time.should_not_receive(:now)
        @account.file_name.should == "useratgmail.com_#{@time.strftime('%Y%m%d%H%M%S')}"
    end
end

describe Account, "id" do
    # username can never have a "_"
    it "should be concatenation of hashes of two components of file_name" do
        account = Account.new
        account.stub!(:file_name).and_return("user_2008090102121012")
        account.id.should == "#{'user'.hash}#{'2008090102121012'.hash}"
    end
end

describe Account, "connect" do
    it "should check if the account is valid" do
        account = Account.new
        account.should_receive(:valid?).and_return false
        account.connect
    end

    describe "and account is valid" do
        it "should initialize a MailFetcher to get all emails in a background process" do
            account = ObjectMother.build :account
            account.stub!(:valid?).and_return true
            MailWritter.should_receive(:new).
                    with(account).and_return(stub("writter", :write => "write"))
            account.should_receive(:fork).and_yield.and_return(1)
            Process.should_receive(:detach).with(1)
            account.connect
        end
    end

end