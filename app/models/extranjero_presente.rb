class ExtranjeroPresente < ApplicationRecord
    # strip whitespaces
    def nombres_str=(nombres_str)
        self.nombres = nombres_str.split(" ").map do |word|
            word.strip.titleize
        end.join(" ")
    end
end
