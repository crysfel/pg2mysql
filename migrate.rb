#!/usr/bin/ruby

require 'active_record'
require 'mysql2'
require 'pg'

dbconfig = YAML.load(File.read('config/database.yml'))

ActiveRecord::Base.establish_connection(dbconfig)

ignore_tables = %w(schema_migrations)
t = Time.new

f = File.open("dumps/data-#{t.to_date}.sql", 'w')
f.write("SET SQL_MODE=\"NO_AUTO_VALUE_ON_ZERO\";\n")
f.write("SET time_zone = \"+00:00\";\n\n")


ActiveRecord::Base.connection.tables.each do |table|
    if !ignore_tables.include? table 
        fields = ""

        #c.name , c.type.to_s , c.limit.to_s
        i = 0
        ActiveRecord::Base.connection.columns(table).each do |c|
            fields += ' ,' if i > 0
            fields += c.name
            i += 1
        end

        results = ActiveRecord::Base.connection.execute("select #{fields} from #{table}")
        f.write("#Table #{table}\n");
        puts "Processing table #{table}"
        results.each do |data|
            values = ''
            j = 0
            data.values.each do |v| 
                values += ',' if j > 0
                if !v.nil?
                    if v == 't'
                        values += "TRUE"
                    elsif v == 'f'
                        values += "FALSE"
                    else
                        values += "'" + v.gsub(/\\/,"\\\\\\").gsub(/\r\n+/,"\\\\n").gsub(/\n+/,"\\\\n").gsub(/'/,"\\\\'")  + "'"
                    end
                else
                    values += 'NULL'
                end

                j += 1
            end
            f.write("insert into #{table} (#{fields}) values (#{values});\n")
        end
        f.write("\n\n");
    end
end

f.close