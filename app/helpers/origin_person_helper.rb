module OriginPersonHelper
    def calculate_age(birthday)
        now = Time.zone.today
        age = now.year - birthday.year
        age -= 1 if now.month < birthday.month || (now.month == birthday.month && now.day < birthday.day)
        age
    end
end
