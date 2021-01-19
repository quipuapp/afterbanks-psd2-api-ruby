module AfterbanksPSD2
  class Resource
    def initialize(data)
      data = sanitize_data(data)
      generate_attr_readers
      set_data(data)
    end

    def fields_information
      self.class.fields_information
    end

    private

    def sanitize_data(data)
      data.inject({}) do |hash, (key, value)|
        hash[key.to_sym] = value

        hash
      end
    end

    def generate_attr_readers
      fields_information.each do |field, _|
        define_singleton_method(field) do
          instance_variable_get("@#{field}")
        end
      end
    end

    def set_data(data)
      fields_information.each do |official_name, field_information|
        raw_value = nil

        if original_name = field_information[:original_name]
          raw_value = data[original_name]
        end

        raw_value ||= data[official_name]

        next if raw_value.nil?

        type = field_information[:type]
        value = value_for(raw_value, type)

        instance_variable_set("@#{official_name}", value)
      end
    end

    def value_for(raw_value, type)
      case type
      when :boolean
        [true, "1", 1].include?(raw_value)
      when :date
        if raw_value.is_a?(Date)
          raw_value
        else
          Date.parse(raw_value)
        end
      else
        raw_value
      end
    end

    def marshal_dump
      dump = {}

      fields_information.each do |field, _|
        dump[field] = send(field)
      end

      dump
    end

    def marshal_load(serialized_resource)
      initialize(serialized_resource)
    end

    class << self
      def fields_information
        @fields_information
      end

      def has_fields(fields_information)
        @fields_information = fields_information
      end
    end
  end
end
