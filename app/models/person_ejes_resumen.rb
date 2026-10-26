class PersonEjesResumen < ApplicationRecord
    def delitos_array
        @delitos_array ||= delitos.split("\n")
    end

    def sentencias_array
        @sentencias_array ||= sentencias.split("\n")
    end
end
