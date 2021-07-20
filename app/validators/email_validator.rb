class EmailValidator < ActiveModel::EachValidator
  EMAIL = /\A([^@\s<>]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze

  def validate_each(record, attribute, value)
    record.errors.add(attribute, (options[:message] || :invalid_email)) unless value =~ EMAIL
  end
end
