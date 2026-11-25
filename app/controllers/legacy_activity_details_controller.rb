class LegacyActivityDetailsController < ApplicationController
    def index
        @legacy_activity_details = LegacyActivityDetail.all

        if params[:s].present? && params[:s].length > 2
            @legacy_activity_details = @legacy_activity_details.where(
                "nombre ILIKE ?",
                "%#{params[:s].strip}%"
            )
        end

        @legacy_activity_details = @legacy_activity_details.ordered.page(params[:page]).per(20)
    end
end
