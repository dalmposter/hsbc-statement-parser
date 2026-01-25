require 'hsbc_pdf_statement_parser'
require 'csv'

for statement in ["2026-01-19_Statement.pdf"]
    parsed = HsbcPdfStatementParser.parse( statement )

    CSV.open('output/' + statement + '.csv', 'w') do |csv|
        #csv << ["Paid", "Date", "Vendor", "Category", "Category (Simplified)", "Paid`", "Balance", "Sheet"]
        parsed.transactions.each do |tx|
            printf( 
                "%s {%-3s} %-40s %7.02f  |  %7.02f\n", 
                tx.date, 
                tx.type,
                tx.details.lines.first.strip, 
                tx.change,
                tx.balance
            )
            csv << [
                Float(tx.change),
                tx.date,
                tx.details.gsub(/\n/, " "),
                '',
                '',
                '',
                Float(tx.balance),
                ''
            ]
        end
    end
end