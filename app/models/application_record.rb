class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def reload_attribute(attr)
    self[attr] = self.class.where(id: id).limit(1).pluck(attr).first
    self
  end

  def graphql_id
    Base64.urlsafe_encode64("#{self.class}---#{self.id}")
  end
end
