class ObjectMother
    module ModelBuilder
        def build(model_name, overrides = {}, &block)
            build_or_create false, model_name, overrides, &block
        end
    end
    extend ModelBuilder

    module ModelBuildOrCreate
        def build_or_create(create, model_name, overrides, &block)
            model_class = model_name.to_s.classify.constantize
            returning model_class.new do |instance|
                valid_attributes_for(model_name).merge(overrides).each_pair do |attribute, value|
                    instance.send("#{attribute}=", value)
                end
                yield instance if block_given?
                instance.save! if create
            end
        end

        private :build_or_create
    end
    extend ModelBuildOrCreate

    module ValidAttributeDefinitionsForModels
        def self.extended(klass)
            klass.cattr_accessor :__valid_attribute_mapping__
            klass.__valid_attribute_mapping__ ||= {}
        end

        def define_valid_attributes_for(model_name, &block)
            __valid_attribute_mapping__[model_name] = block
        end

        def valid_attributes_for(model_name, overrides = {})
            return {} unless attributes = __valid_attribute_mapping__[model_name]
            attributes.call.merge(overrides)
        end
    end
    extend ValidAttributeDefinitionsForModels

    define_valid_attributes_for :account do
        {:email_address => "email address", :server => "server", 
            :username => "username", :password => "password", :port => 995}
    end

end
