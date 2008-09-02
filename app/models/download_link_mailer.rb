class DownloadLinkMailer < ActionMailer::Base
  def download_link(account)
      @subject    = "Your email archive download link"
      @body['body_text'] = "Your email has been archived. you can download you email archive in mbox form at http://getmyemails.selfip.com:3000/download/#{account.id}"
      @recipients = account.email_address
      @from       = "no-reply@example.com"
  end

end
