class LegacyCourseFileParser < ApplicationRecord
    validates :parser_name, presence: true

    def id_and_type
        [ id, self.class.to_s ].join("_")
    end
end
