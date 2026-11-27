# Resolves identifying and location details for a legacy person from current records.
#
# DNI and location are matched by uppercased name; detention date comes from the
# earliest legal process for a matching origin person.
class PersonDataService
    attr_reader :dni, :ubicacion, :fecha_detencion

    # @param legacy_person [LegacyPerson] record used to resolve matching person data
    def initialize(legacy_person)
        @legacy_person = legacy_person

        ##
        # search by name
        nombre_upcased = @legacy_person.nombres.upcase
        current_person = Person.find_by(nombres: nombre_upcased)
        origin_person = OriginPerson.find_by(fullname: nombre_upcased)

        @dni = @legacy_person.dni.presence || current_person.try(:dni)
        @ubicacion = current_person.try(:pabellon)

        if origin_person.present?
            first_origin_person_legal_process = origin_person.origin_person_legal_processes.order(fecha_detencion: :asc).first
            @fecha_detencion = first_origin_person_legal_process.fecha_detencion
        end
    end
end
