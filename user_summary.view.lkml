view: user_summary {
  derived_table: {
    sql:
    SELECT
        CONCAT(u.first_name, ' ', u.last_name) AS user,
        u.id AS user_id,
        SUM(oi.sale_price) AS total_sales_from_user,
        AVG(oi.sale_price) AS avg_revenue_from_user,
        COUNT(DISTINCT oi.id) AS distinct_items,
        COUNT(DISTINCT CASE WHEN (oi.sale_price > {% parameter threshold %}) THEN oi.id ELSE NULL END) AS count_distinct_items_over_threshold
      FROM
      order_items oi LEFT JOIN orders o ON
      oi.order_id = o.id LEFT JOIN users u ON
      o.user_id = u.id
      GROUP BY 1, 2
       ;;
      persist_for: "24 hours"
      indexes: ["user"]
  }

  parameter: threshold {
    type: number
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user {
    type: string
    sql: ${TABLE}.user ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_sales_from_user {
    type: number
    sql: ${TABLE}.total_sales_from_user ;;
  }

  dimension: avg_revenue_from_user {
    type: number
    sql: ${TABLE}.avg_revenue_from_user ;;
  }

  dimension: distinct_items {
    type: number
    sql: ${TABLE}.distinct_items ;;
  }

  dimension: count_distinct_items_over_threshold {
    type: number
    sql: ${TABLE}.count_distinct_items_over_threshold ;;
  }

  set: detail {
    fields: [
      user,
      user_id,
      total_sales_from_user,
      avg_revenue_from_user,
      distinct_items,
      count_distinct_items_over_threshold
    ]
  }
}
