class MailWritter
    attr_reader :account
    def initialize(account)
        @account = account
    end

    def write
        account.start_connection do |mails|
            File.open("#{RAILS_ROOT}/public/mboxes/"+account.file_name, 'w') do |f|
                mails.each_mail do |mail|
                    f.write mail.pop.to_mbox_format
                end
            end
        end
        DownloadLinkMailer.deliver_download_link(@account)
    end
end