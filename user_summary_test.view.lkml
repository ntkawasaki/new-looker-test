include: "*.view.lkml"

explore: user_summary_test {
  join: users {
    relationship: one_to_one
    sql_on: ${users.id} = ${user_summary_test.users_id} ;;
  }
}

view: user_summary_test {
  derived_table: {
    sql: SELECT
        users.id  AS `users.id`,
        {% parameter measure_type%}(orders.id ) AS `orders.dynamic_metric`
      FROM demo_db.order_items AS order_items
      LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
      LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id

      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 500
       ;;
  }


  parameter: measure_type {
    type: unquoted
    allowed_value: {
      label: "Sum"
      value: "SUM"
    }
    allowed_value: {
      label: "Max"
      value: "MAX"
    }
    allowed_value: {
      label: "Min"
      value: "MIN"
    }
    allowed_value: {
      label: "Count"
      value: "COUNT"
    }
    allowed_value: {
      label: "Average"
      value: "AVG"
    }
  }

  measure: count {
    type: count
  }

  dimension: users_id {
    type: number
    sql: ${TABLE}.`users.id` ;;
  }

  dimension: dynamic_metric {
    type: number
    sql: ${TABLE}.`orders.dynamic_metric` ;;
  }

  dimension: dynamic_metric_tier {
    type: tier
    tiers: [0, 50, 100, 500]
    sql: ${dynamic_metric} ;;
  }

#   set: detail {
#     fields: [users_id, orders_count]
#   }
}
