class LegacyCourseFileParser < ApplicationRecord
    validates :parser_name, presence: true

    def id_and_type
        [ id, self.class.to_s ].join("_")
    end

    def ignore_specific_rows_array
        @ignore_specific_rows_array ||= ignore_specific_rows.split("\n").map(&:downcase)
    end
end
