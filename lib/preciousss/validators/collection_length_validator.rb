class CollectionLengthValidator < ActiveModel::Validations::LengthValidator

  def validate_each(record, attribute, value)
    CHECKS.each do |key, validity_check|
      next unless check_value = options[key]

      value ||= [] if key == :maximum

      # Changed value.size to value.length here
      next if value && value.length.send(validity_check, check_value)

      errors_options = options.except(*RESERVED_OPTIONS)
      errors_options[:count] = check_value

      default_message = options[MESSAGES[key]]
      errors_options[:message] ||= default_message if default_message

      record.errors.add(attribute, MESSAGES[key], errors_options)
    end
  end

end