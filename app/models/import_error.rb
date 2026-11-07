class ImportError < ApplicationRecord
    attr_accessor :details_object

    before_save :serialize_details!

    def details_object
       @details_object ||= YAML.load(details)
    end

    private

    def serialize_details!
        self.details = details_object.to_yaml
    end
end
