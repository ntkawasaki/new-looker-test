explore: my_sql_runner_query {}

view: my_sql_runner_query {
  derived_table: {
    sql: select status, COUNT(*) from orders group by 1 ;
      ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}.`COUNT(*)` ;;
  }

  set: detail {
    fields: [status, count]
  }
}
