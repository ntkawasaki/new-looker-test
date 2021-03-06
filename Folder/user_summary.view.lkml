view: user_summary {
  derived_table: {
    sql:
    SELECT
        CONCAT(u.first_name, ' ', u.last_name) AS user,
        u.id AS user_id,
        SUM(oi.sale_price) AS total_sales_from_user,
        AVG(oi.sale_price) AS avg_revenue_from_user
      FROM
      order_items oi LEFT JOIN orders o ON
      oi.order_id = o.id LEFT JOIN users u ON
      o.user_id = u.id
      GROUP BY 1, 2
;;

      persist_for: "24 hours"
#       indexes: ["user"]
  }

  parameter: dynamic_id {
    type: string
  }


  measure: count {
    type: count
  }

  dimension: user {
    type: string
    sql: ${TABLE}.user ;;
    link: {
      label: "Dashboard 0"
      url: "/dashboards/0..."
    }
    link: {
      label: "Dashboard 1"
      url: "/dashboards/1..."
    }
    link: {
      label: "Dashboard 2"
      url: "/dashboards/2..."
    }
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_sales_bucket {
    type: tier
    tiers: [100, 200, 500]
    sql: ${total_sales_from_user} ;;
  }

  dimension: total_sales_from_user {
    type: number
    sql: ${TABLE}.total_sales_from_user ;;
  }

  dimension: avg_revenue_from_user {
    type: number
    sql: ${TABLE}.avg_revenue_from_user ;;
  }



}
