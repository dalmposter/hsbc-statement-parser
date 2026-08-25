module HsbcPdfCreditStatementParser
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
          @reader.pages.map.with_index do |page, i|
            if i == 0
              nil
            else
              # Matcher for when the first page is also the last page
              match = page.text.match(/Received\s*By\s*Us\s*Transaction\s*Date\s*Details\s*(.*)\sSummary\s?Of\s?Interest\s?On\s?This\sStatement/im)
              if match.nil?
                # Matcher for the first page
                match = page.text.match(/Received\s*By\s*Us\s*Transaction\s*Date\s*Details\s*(.*)$/im)
              end
              if match.nil?
                # Matcher for last page
                match = page.text.match(/Sheet\s?Number\s?.\s?of\s?.\s?[^\n]+\n(.*)\sSummary\s?Of\s?Interest\s?On\s?This\sStatement/im)
              end
              if match.nil?
                # Matcher for middle pages
                match = page.text.match(/Sheet\s?Number\s?.\s?of\s?.\s?[^\n]+\s*(.*)$/im)
              end

              # Fix for if the last page just contains informational text
              match ? match[1].start_with?('We now provide more information') ? nil : match[1] : nil
            end
          end.compact
        end
    end
  end
end
