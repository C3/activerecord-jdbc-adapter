module ArJdbc
  module Teradata
    module LimitHelpers

      FIND_SELECT = /\b(SELECT(?:\s+DISTINCT)?)\b(.*)/im # :nodoc:

      module TeradataReplaceLimitOffset

        module_function

        def replace_limit_offset!(sql, limit, offset, order)
          if limit
            offset ||= 0
            start_row = offset + 1
            end_row = offset + limit.to_i
            _, select, rest_of_query = FIND_SELECT.match(sql).to_a
            rest_of_query.strip!
            if rest_of_query[0...1] == "1" && rest_of_query !~ /1 AS/i
              rest_of_query[0] = "*"
            end
            if rest_of_query[0...1] == "*"
              from_table = Utils.get_table_name(rest_of_query, true)
              rest_of_query = from_table + '.' + rest_of_query
            end
            # teradata 12
            new_sql = "SELECT ROW_NUMBER() OVER(ORDER BY #{order.gsub('ORDER BY', '')}) AS _row_num, #{rest_of_query}"
            new_sql << " QUALIFY _row_num BETWEEN #{start_row.to_s} AND #{end_row.to_s}"
            # teradata 13+
            # new_sql = "#{select} t.* FROM (SELECT ROW_NUMBER() OVER(ORDER BY #{order.gsub('ORDER BY', '')}) AS _row_num, #{rest_of_query}"
            # new_sql << ") AS t WHERE t._row_num BETWEEN #{start_row.to_s} AND #{end_row.to_s}"
            sql.replace(new_sql)
          end
          sql
        end

      end

    end
  end
end
