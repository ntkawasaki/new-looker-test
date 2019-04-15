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
    hidden: yes
    sql: ${TABLE}.brand ;;
#     html: {{value}}<p>                                                               </p> ;;
#     link: {
#       label: "Brand Lookup Dashboard"
#       url: "https://localhost:9999/dashboards/3?Brand={{value}}"
#     }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }


  dimension: number {
    type: string
    sql: 234243 ;;
  }

  dimension: long_description {
    type: string
    sql: 'Really really really really really really really really long string';;
    html: {{ value | truncate: 8, '...' }} ;;
  }

#   dimension: category_liquid {
#     type:  string
#     sql: {{ _filters['products.category'] }} ;;
#   }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: 1_or_0 {
    type: number
    sql: CASE WHEN ${department} = 'Men' THEN 1 ELSE 0 END ;;
  }

  dimension: true_false {
    type: string
    sql: CASE WHEN ${department} = "Men" THEN "true" ELSE "false" END ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
    action: {
      label: "Test"
      url: "https://www.google.com"
      param: {
        name: "name"
        value: "value"
      }

    }
  }

  dimension: rank {
    type: number
    hidden: yes
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
#     required_fields: [rank]
  }
}
