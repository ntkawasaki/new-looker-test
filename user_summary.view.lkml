view: user_summary {
  derived_table: {
    sql:
    SELECT
        CONCAT(u.first_name, ' ', u.last_name) AS user,
        u.id AS user_id,
        SUM(oi.sale_price) AS total_sales_from_user,
        AVG(oi.sale_price) AS avg_revenue_from_user,
      FROM
      order_items oi LEFT JOIN orders o ON
      oi.order_id = o.id LEFT JOIN users u ON
      o.user_id = u.id
      GROUP BY 1, 2
       ;;
      persist_for: "24 hours"
      indexes: ["user"]
  }
#         --COUNT(DISTINCT oi.id) AS distinct_items

  measure: count {
    type: count
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

}
