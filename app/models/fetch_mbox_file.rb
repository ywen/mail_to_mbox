class FetchMboxFile 
    attr_reader :file_id
    def initialize(file_id)
        @file_id = file_id
    end
    
    def address
        file = Dir.open("#{RAILS_ROOT}/public/mboxes") do |dir|
            dir.entries.find {|file_name| IdMatcher.new(file_id, file_name).match?}
        end
        "/mboxes/#{file}"    
    end
    
    class IdMatcher
        extend ObfuscatedString
        
        attr_reader :file_id, :file_name
        generate_obfuscated_string_method :obfuscated_string, :file_name
        
        def initialize(file_id, file_name)
            @file_id = file_id
            @file_name = file_name
        end
        
        def match?
            obfuscated_string == file_id
        end
    end
end