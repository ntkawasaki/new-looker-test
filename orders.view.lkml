view: orders {
  sql_table_name: demo_db.orders ;;

  parameter: date_granularity {
    allowed_value: {
      label: "Week"
      value: "Week"
    }
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      month_name,
      month_num
    ]
    sql: ${TABLE}.created_at ;;
  }


  dimension: c_or_p {
    type: string
    sql:
      CASE
        WHEN (${created_raw} > "2017-10-01" THEN "C")
        WHEN (${created_raw} < "2017-10-01" AND ${created_raw} > "2016-10-01") THEN "P"
      END
    ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: new_status {
    type: string
    sql: ${status} ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.first_name, users.last_name, users.id, order_items.count]
  }

  measure: count_divided {
    type: number
    sql: COUNT(*)/4000 ;;
  }

  measure: count_without_liquid_link {
    type: count
  }

  measure: count_with_liquid_link {
    type: count
    link: {
      label: "Hello World!"
      url: "https://www.google.com/search?q={{ status._value }}"
    }
  }

  measure: completed_count {
    type: count
    filters: {
      field: status
      value: "completed"
    }
  }

  measure: pending_count {
    type: count
    filters: {
      field: status
      value: "pending"
    }
  }






  measure: completed_over_pending {
    type: number
    sql: ${completed_count} / COALESCE(${pending_count}, 0) ;;
    html: {{ value | round: 1 }} ;;
  }

  measure: cancelled_count {
    type: count
    filters: {
      field: status
      value: "cancelled"
    }
  }


}
