class ImportBateriaIndicadoresTask
    def initialize(xlsx)
        @xlsx = xlsx
        @sheet = @xlsx.sheet(0)
    end

    def import!
        assert_pre_headers!
        assert_headers!

        import_count = 0
        skip_headers = 6
        current_row_n = 0
        @sheet.each do |row|
            if current_row_n < skip_headers
            # puts "skip header"
            else
                indicadores_row = BateriaIndicadoresRow.new(
                    row
                )
                import_count += 1 if indicadores_row.import!
                puts "#{current_row_n}: #{indicadores_row.fullname}"
            end
            current_row_n += 1
        end

        puts "imported #{import_count} records"
    end

    private

    def assert_pre_headers!
        if @sheet.row(5) != Rails.application.config_for(:bateria_indicadores)[:pre_headers]
            raise "pre-headers wrong"
        end
    end

    def assert_headers!
        if @sheet.row(6) != Rails.application.config_for(:bateria_indicadores)[:headers]
            missing = []
            @sheet.row(6).each do |col|
                unless Rails.application.config_for(:bateria_indicadores)[:headers].include?(col)
                    missing << col
                end
            end
            puts "missing: #{missing}"
            raise "headers wrong"
        end
    end
end
