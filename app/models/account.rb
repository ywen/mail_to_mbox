require 'pop_ssl'

class Account
    include Validatable
    extend ObfuscatedString

    attr_accessor :server, :port, :ssl, :email_address, :username, :password

    validates_presence_of :email_address, :server, :username, :password, :port
    validates_numericality_of :port, :level => 2
    validates_each :base, :logic => lambda{
        begin
            start_connection
        rescue Exception => e
            errors.add(:base, e.message)
        end
    }, :level => 3
    generate_obfuscated_string_method :id, :file_name

    def initialize(params={})
        params.each_pair do |key, value|
            self.send("#{key}=", value)
        end
    end

    def ssl?
        ssl == "1"
    end

    def file_name
        @file_name ||= "#{email_address.gsub('@', 'at')}_#{Time.now.strftime('%Y%m%d%H%M%S')}"
    end

    def start_connection
        Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if ssl?
        Net::POP3.start(server, port.to_i, username, password) do |pop|
            yield(pop) if block_given?
        end
    end

    def connect
        return false unless valid?
        Process.detach(fork do
            MailWritter.new(self).write
        end)
    end

end
