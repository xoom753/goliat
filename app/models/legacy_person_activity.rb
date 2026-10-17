class LegacyPersonActivity < ApplicationRecord
    # before_save :set_start_and_end_dates!

    private

    # def set_start_and_end_dates!
    #     # example: "01/11/2025 AL 30/11/2025"
    #     self.start_date = activity_dates[0, 10] # "01/11/2025"
    #     self.end_date = activity_dates[-10, 10] # "30/11/2025"
    # end
end
