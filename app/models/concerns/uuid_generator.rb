module UuidGenerator
  extend ActiveSupport::Concern

  included do
    def self.has_uuid(attrs)
      raise ArgumentError if attrs.blank?

      self.class_variable_set(:@@uuid_generator_attributes, Array.wrap(attrs))

      class_eval do
        def save
          uuid_generator_set_uuids if self.new_record?
          super
        end

        def save!
          uuid_generator_set_uuids if self.new_record?
          super
        end

        private

        def uuid_generator_set_uuids
          self.class.class_variable_get(:@@uuid_generator_attributes).each do |attr|
            self.send("#{attr}=", uuid_generator_gen_uuid) if self.send(attr).blank?
          end
        end

        def uuid_generator_gen_uuid
          SecureRandom.uuid
        end
      end
    end
  end
end
