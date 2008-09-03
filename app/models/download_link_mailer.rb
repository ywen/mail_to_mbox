class DownloadLinkMailer < ActionMailer::Base
  def download_link(account)
      @subject    = "Your email archive download link"
      @body['body_text'] = "Your email has been archived. you can download you email archive in mbox form at #{base_host}/download/#{account.id}"
      @recipients = account.email_address
      @from       = "no-reply@example.com"
  end

  private
  def base_host
    ENV['MAIL_TO_MBOX_BASE_HOST'] || "http://localhost:3000"
  end
end
