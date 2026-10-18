class LegacyFilesParser < ApplicationRecord
    def id_and_type
        [id, self.class.to_s].join("_")
    end
end
