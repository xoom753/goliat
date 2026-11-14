module ImportLegacyFilesHelper
    def q_button_filter(kind)
        q_str = nil
        if params[:q] == kind
            btn_class = "is-link"
        else
            q_str = kind
            btn_class = "is-ghost"
        end

        link_to kind.titleize,
                import_legacy_files_path(filter_params.merge(q: q_str)),
                class: "button #{btn_class}"
    end

    def year_button_filter(year)
        year_str = nil
        if params[:year] == year.to_s
            btn_class = "is-link"
        else
            year_str = year
            btn_class = "is-ghost"
        end

        link_to year,
                import_legacy_files_path(filter_params.merge(year: year_str)),
                class: "button #{btn_class}"
    end

    private

    def filter_params
        {
            q: params[:q],
            year: params[:year],
            status: params[:status]
        }
    end
end
