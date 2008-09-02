class MailToMboxesController < ApplicationController
    def new
        @account = Account.new
    end
    
    def create
        @account = Account.new(params[:account])
        if @account.connect
            redirect_to thank_you_mail_to_mbox_path, :id => @account.id
        else
            render :action => "new"
        end
    end
    
    def thank_you
    end
end