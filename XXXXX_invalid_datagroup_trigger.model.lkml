connection: "thelook"

datagroup: sick_datagroup {
  sql_trigger: SELECT CURDATE() ;;
}

explore: random_table {
  hidden: yes
  from: order_items
  join: orders {
    relationship: many_to_one
    type: left_outer
    sql_on: ${random_table.order_id} = ${orders.id} ;;
  }
}

explore: derived_table_1 {
  hidden: yes
}

explore: derived_table_2 {
  hidden: yes
}

view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
  }
}

view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: []
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

view: derived_table_1 {
  derived_table: {
    sql:
        SELECT *
        FROM demo_db.order_items oi
        LEFT JOIN demo_db.orders o ON oi.order_id = o.id ;;
    datagroup_trigger: sick_datagroup
    indexes: ["order_id"]
  }
}

view: derived_table_2 {
  derived_table: {
    sql:
        SELECT *
        FROM ${derived_table_1.SQL_TABLE_NAME} ;;
    datagroup_trigger: sick_datagroup
    indexes: ["order_id"]
  }

}
