module ObfuscatedString
    def generate_obfuscated_string_method(method_name, start_string_method)
        class_eval <<-EOS
        def #{method_name}
            string = #{start_string_method}            
            strings = string.to_s.split('_')
            strings[0].hash.to_s + strings[1].hash.to_s
        end
        EOS
    end
end