class PlanDeVidaImporter
    ##
    # cultural (see headers)
    def initialize(file_name)
        @xlsx = Roo::Spreadsheet.open(file_name, extension: :xlsx)
        @sheet = @xlsx.sheet('REPORTE INDIVIDUAL')
        
    end

    def rows_hash
        parsing_first_row = true
        sheet.each(
            num: 'N°',
            nombres: 'APELLIDOS Y NOMBRES DE LA PPL (REPORTAR PARTICIPACIONES)',
            servicios: "SERVICIOS ARTÍSTICOS CULTURALES",
            actividad: "NOMBRE DE LA ACTIVIDAD CULTURAL",
            fecha: "FECHA DE LA ACTIVIDAD",
            duracion: "DURACIÓN DE LA ACTIVIDAD (EN HORAS)"
        ) do |hash|
            if parsing_first_row
                parsing_first_row = false
            elsif hash[:nombres].present?
                legacy_person_activity = LegacyPersonActivity.new(
                    row_number: hash[:num],
                    nombres: hash[:nombres].strip,
                    activity_group_str: hash[:servicios],
                    activity_str: hash[:actividad],
                    activity_dates: hash[:fecha].strip,
                    duracion: hash[:duracion]
                )
                legacy_person_activity.save!
            end
        end
    end

    private


end
