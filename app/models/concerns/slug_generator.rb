module SlugGenerator
  def self.included(base)
    base.extend ClassMethods

    base.class_eval do
      def save(*args)
        slug_generator_update_slug
        super
      end

      def save!(*args)
        slug_generator_update_slug
        super
      end

      private

      def slug_generator_update_slug
        attribute = self.class.class_variable_get(:@@slug_generator)
        raise RuntimeError, 'Slug origin is not defined or not exist' if attribute.nil? || !self.respond_to?(attribute)

        return unless self.send("#{attribute}_changed?")

        origin_value = self.send(attribute)
        self.slug = "#{slug_generator_gen_slug(origin_value)}"
      end

      def slug_generator_gen_slug(origin_value)
        origin_value.strip.squeeze.downcase.gsub(/[^0-9a-z\s]/, '').gsub(' ', '-')
      end
    end
  end

  module ClassMethods
    def slug_generator(attribute)
      self.class_variable_set(:@@slug_generator, attribute)
    end
  end
end
