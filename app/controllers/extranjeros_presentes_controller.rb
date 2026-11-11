class ExtranjerosPresentesController < ApplicationController
    def index
        @extranjeros_presentes = ExtranjeroPresente.all
    end
end
