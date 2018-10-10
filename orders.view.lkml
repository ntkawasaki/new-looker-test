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

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
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
