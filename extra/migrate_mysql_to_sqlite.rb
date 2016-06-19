#!/usr/bin/env ruby
# encoding: UTF-8

require 'yaml'
require 'mysql2'
require 'sqlite3'

# Trivial converter MySQL -> Sqlite.
#
# IMPORTANT: This script is for internal use, so no escaping is applied to
# schema-related names.
#
class MigrateMySqlToSqlite

  def transfer(source_connection_data, destination_connection_data)
    source_connection = open_mysql_connection(source_connection_data)
    destination_connection = open_sqlite_connection(destination_connection_data)

    tables = find_tables(source_connection)

    tables.each do |table|
      source_records_count = count_records(table, source_connection)

      print "#{ table } (#{ source_records_count }): "

      copy_table_content(table, source_connection, destination_connection)

      puts
    end
  end

  private

  def open_mysql_connection(source_connection_data)
    Mysql2::Client.new(source_connection_data)
  end

  def open_sqlite_connection(destination_connection_data)
    SQLite3::Database.new(destination_connection_data.fetch('database'))
  end

  def find_tables(mysql_connection)
    schema = mysql_connection.query_options.fetch(:database)

    sql = "
      SELECT table_name
      FROM information_schema.tables
      WHERE table_schema = '#{ schema }'
    "

    results = mysql_connection.query(sql)

    results.map { |result| result['table_name']}
  end

  def count_records(table, mysql_connection)
    mysql_connection.query("SELECT COUNT(*) FROM `#{ table }`").first.values.first
  end

  # This is quite a hairy task. The current options are not really viable:
  #
  #   - SQL::Translator requires either perl programming, or a CGI script as GUI (!)
  #   - various script around are generally hacks
  #   - FullConvert (v6.11) fails the conversion, and the changelog doesn't mention
  #     improvements on recent versions.
  #
  # All in all, the solid/usable tools seem only the commercial ones (not even all
  # of them).
  #
  # There are several approaches for manual conversion, in this case:
  #
  #   - a generic approach is used (no relying on ActiveRecord models)
  #   - assumptions are made (eg. tinyint(3) is a boolean)
  #   - a monolithic conversion logic is used
  #
  # Note that it's assumed that the destination tables are already created, and match
  # the source ones as intended (ie. ordering, data types).
  #
  def copy_table_content(table, source_connection, destination_connection)
    column_types = find_column_types(table, source_connection, destination_connection)
    records = find_source_records(source_connection, table)

    destination_connection.transaction do
      records.each do |record|
        sql = "INSERT INTO #{ table } VALUES ("
        converted_values = []

        record.values.zip(column_types).each_with_index do |(value, (source_type_data, destination_type)), column_i|
          sql << ', ' if column_i > 0
          sql << '?'

          converted_value = convert_value(value, source_type_data, destination_type, destination_connection)

          converted_values << converted_value
        end

        sql << ")"

        destination_connection.execute(sql, *converted_values)

        print '.'
      end
    end
  end

  # Output:
  #
  #     [
  #       [source_type, destination_type],
  #       ...
  #     ]
  #
  #     source_type:      [type, numeric_precision]
  #     destination_type: type
  #
  def find_column_types(table, source_connection, destination_connection)
    schema = source_connection.query_options.fetch(:database)

    sql = "
      SELECT DATA_TYPE, NUMERIC_PRECISION
      FROM information_schema.COLUMNS
      WHERE table_schema = '#{ schema }' AND TABLE_NAME = '#{ table }'
      ORDER BY ORDINAL_POSITION
    "

    source_types = source_connection.query(sql).to_a.map(&:values)

    sql = "PRAGMA table_info('#{ table }')"

    destination_types = destination_connection.execute(sql).map { |result| result[2].downcase }

    source_types.zip(destination_types)
  end

  def find_source_records(source_connection, table)
    source_connection.query("SELECT * FROM #{ table }")
  end

  def convert_value(value, source_type_data, destination_type, destination_connection)
    if source_type_data == ['tinyint', 3]
      # Rails-specific: strings are used.
      #
      value == 1 ? 't' : 'f'
    else
      case source_type_data[0]
      when 'varchar', /text$/
        value
      when /int$/, 'year'
        value
      when 'datetime'
        # Rails stores the UTC value. Even with nanoseconds!!
        #
        value.utc.strftime('%F %T.%6N')
      when 'mediumblob'
        value
      else
        raise "Unsupported conversion!: #{ source_type_data } => #{ destination_type }"
      end
    end
  end
end

if __FILE__ == $0
  # See `migrate_mysql_to_sqlite.yml.tmpl` for the template.
  #
  configuration = YAML.load_file(File.expand_path('../migrate_mysql_to_sqlite.yml', __FILE__))

  MigrateMySqlToSqlite.new.transfer(configuration.fetch('source_connection_data'), configuration.fetch('destination_connection_data'))
end
