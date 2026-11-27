# Selects the legacy or current social-axis grading table for a report period.
class PersonEjesResumen::SpecificFichaRendererService::FichasSocialRenderer < PersonEjesResumen::SpecificFichaRendererService::FichasCommonRenderer
    # Renders the social table matching the current period's format.
    # @return [Object] document table result
    def grades_table
        if @current_periodo.is_formato_antiguo?
            formato_antiguo_table
        else
            formato_actual_table
        end
    end

    private

    def formato_antiguo_table
        PersonEjesResumen::SpecificFichaRendererService::FichasSocialRenderer::FormatoAntiguoRenderer.new(docx: docx).table
    end

    def formato_actual_table
        PersonEjesResumen::SpecificFichaRendererService::FichasSocialRenderer::FormatoActualRenderer.new(
            docx: docx,
            semestre: get_semestre,
            person_ejes_resumen: @person_ejes_resumen,
            periodos: periodos
        ).table
    end
end
