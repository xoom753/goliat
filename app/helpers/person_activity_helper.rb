module PersonActivityHelper
    def person_activity_cargos_for_select
        PersonActivity.cargos.map do |v, k|
            [ k, I18n.t("person_activity.cargos.#{v}") ]
        end
    end
end
