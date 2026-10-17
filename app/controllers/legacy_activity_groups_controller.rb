class LegacyActivityGroupsController < ApplicationController
    def index
        @legacy_activity_groups = LegacyActivityGroup.all.page(params[:page]).per(100)
    end
end
