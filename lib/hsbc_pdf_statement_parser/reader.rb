module HsbcPdfStatementParser
  class Reader
    def initialize(filename)
      @reader = PDF::Reader.new(filename)
    end

    def first_page
      @_first_page ||= @reader.pages.first.text
    end

    def all_text
      @_all_text ||= @reader.pages.map(&:text).join
    end

    def statement_blocks
      @_statement_lines ||= begin
          @reader.pages.map do |page|
            match = page.text.match(/BALANCE\s?BROUGHT\s?FORWARD(?:.*?)\n(.*?)BALANCE\s?CARRIED\s?FORWARD/im)
            if match.nil?
              # Patch to make the parsing work for the first ever statement of an account
              match = page.text.match(/\nA\s(?:.*?)\n(.*?)BALANCE\s?CARRIED\s?FORWARD/im)
            end
            match ? match[1] : nil
          end.compact
        end
    end
  end
end
