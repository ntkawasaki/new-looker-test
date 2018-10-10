view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
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
      year,
      month_name,
      month_num
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: sale_price_test {
    type: number
    sql:
      CASE
        WHEN ${returned_date} IS NOT NULL THEN ROUND(${TABLE}.sale_price, 2)
        ELSE ROUND(${TABLE}.sale_price, 3)
      END ;;
  }

  dimension: sale_price_liquid {
    type: number
    sql: ${sale_price} ;;
    html: {% if value > 100 %}
            {{ value }}
          {% else %}
            {{ value | round: 0}}
          {% endif %};;
  }

  # From a chat
  dimension: data_reliability_formatted {
    type: string
    sql: ${TABLE}.data_reliability ;;
    html:
      {% if data_reliability.data_reliability._value == 'Data Reliable' %}
          <p style="color: #585858; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% elsif data_reliability.data_reliability._value == 'Medium Reliability' %}
          <p style="color:#585858; background-color: #FFCC11; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% elsif data_reliability.data_reliability._value == 'Good Coverage - Zero Usage' %}
          <p style="color:#585858; background-color: #FF7F24; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% else %}
          <p style="color:#585858; background-color: #F78181; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% endif %}
      ;;
  }


  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
#     html:
#     {% if value > 30000 %}
#       {{ rendered_value | round: 5}}
#     {% else %}
#       {{ rendered_value | round: 10}}
#     {% endif %};;
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
  }
}
