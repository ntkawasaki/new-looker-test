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

#   filter: hi {
#     type: string
#     sql: ${id} = {%   %}  ;;
#   }

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

  dimension: returned {
    type: yesno
    sql: ${returned_date} IS NOT NULL ;;
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
    sql: ${sale_price} / 1.5;;
#     html:
#     {% if value > 30000 %}
#       {{ rendered_value | round: 5}}
#     {% else %}
#       {{ rendered_value | round: 10}}
#     {% endif %};;
  }

  measure: total_sale_price_liquid {
    type: sum
    sql: ${sale_price} ;;
    html:
    {% if value > 30000 %}
      {{ rendered_value | round: 5}}
    {% else %}
      {{ rendered_value | round: 10}}
    {% endif %};;
  }

  parameter: metric {
    type: unquoted
    allowed_value: {
      label: "usd"
      value: "usd"
    }
    allowed_value: {
      label: "percent"
      value: "percent"
    }
    allowed_value: {
      label: "decimal"
      value: "decimal"
    }
    allowed_value: {
      label: "int"
      value: "int"
    }
  }

  measure: total_sale_price_liquid_with_metrics {
    type: sum
    sql: ${sale_price} / 1.5 ;;
    value_format: "0"
    html:
    {% if metric._parameter_value == 'usd' %}
      ${{ value | round: 3}}
    {% elsif metric._parameter_value == 'percent' %}
      {{ value | round: 2}}%
    {% elsif metric._parameter_value == 'decimal' %}
      {{ value | round: 2}}
    {% elsif metric._parameter_value == 'int' %}
      {{ value | round: 0 }}
    {% endif %};;
  }

  measure: percentile_sale_price {
    type: percentile
    percentile: 75
    sql: ${sale_price} ;;
  }

  parameter: percentile_in_decimals {
    type: number
  }

  measure: percentile_sale_price_liquid {
    type: number
    sql: CASE WHEN CAST(FLOOR(COUNT(order_items.sale_price ) * {% parameter percentile_in_decimals %} - 0.00000001) AS SIGNED) + 1 =
    CAST(FLOOR(COUNT(order_items.sale_price ) * {% parameter percentile_in_decimals %}) AS SIGNED) + 1 OR COUNT(order_items.sale_price ) = 1 THEN
    CAST(REPLACE(SUBSTRING(CAST(GROUP_CONCAT( LPAD(SUBSTRING(CAST(order_items.sale_price  AS CHAR), 1, 20), 20, '*') ORDER BY
    order_items.sale_price   SEPARATOR '' ) AS CHAR), (CAST(FLOOR(COUNT(order_items.sale_price ) * {% parameter percentile_in_decimals %} -
    0.00000001) AS SIGNED) + 1 - 1) * 20 + 1, 20), '*', ' ') AS DECIMAL(20, 5)) ELSE (CAST(REPLACE(SUBSTRING(CAST(GROUP_CONCAT( LPAD(SUBSTRING(CAST(order_items.sale_price  AS
    CHAR), 1, 20), 20, '*') ORDER BY order_items.sale_price   SEPARATOR '' ) AS CHAR), (CAST(FLOOR(COUNT(order_items.sale_price ) * {% parameter percentile_in_decimals %} - 0.00000001) AS SIGNED)
    + 1 - 1) * 20 + 1, 20), '*', ' ') AS DECIMAL(20, 5)) + CAST(REPLACE(SUBSTRING(CAST(GROUP_CONCAT( LPAD(SUBSTRING(CAST(order_items.sale_price  AS CHAR), 1, 20), 20, '*') ORDER BY order_items.sale_price   SEPARATOR '' )
    AS CHAR), (CAST(FLOOR(COUNT(order_items.sale_price ) *{% parameter percentile_in_decimals %}) AS SIGNED) + 1 - 1) * 20 + 1, 20), '*', ' ') AS DECIMAL(20, 5))) / 2 END ;;
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
  }
}
