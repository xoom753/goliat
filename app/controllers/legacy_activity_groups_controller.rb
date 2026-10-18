class LegacyActivityGroupsController < ApplicationController
    def index
        @legacy_activity_groups = LegacyActivityGroup.all.page(params[:page]).per(100)
    end

    def update
        @legacy_activity_group = LegacyActivityGroup.find(
            params[:id]
        )
        @legacy_activity_group.update!(
            legacy_activity_group_params
        )
        redirect_to action: :index
    end

    private

    def legacy_activity_group_params
        params.expect(legacy_activity_group: :activity_group_id)
    end
end
