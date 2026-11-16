class ActivityGroupsController < ApplicationController
    def index
        @activity_groups = ActivityGroup.all
    end
end
