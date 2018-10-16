view: products {
  sql_table_name: demo_db.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    value_format_name: decimal_1
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    html: <a href="https://localhost:9999/dashboards/3?Brand={{value}}" target="_new">{{value}}</a> ;;
    link: {
      label: "Brand Lookup Dashboard"
      url: "https://localhost:9999/dashboards/3?Brand={{value}}"
    }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

#   dimension: category_liquid {
#     type:  string
#     sql: {{ _filters['products.category'] }} ;;
#   }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
    required_fields: [rank]
  }
}
