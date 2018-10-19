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

  dimension: really_long_id {
    type: number
    sql: 111222333444555666 * 1.0 ;;
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

  dimension: if_order_id_or_inventory_id_test {
    type: string
    sql:
    {% if order_id._in_query or inventory_item_id._in_query %}
    "IT WORKED"
    {% else %}
    "ELSE"
    {% endif %}
    ;;
  }

  dimension: returned_liquid_bang_if {
    type: yesno
    sql: ${returned_date} IS NOT NULL ;;
    html:
      {% if value != 'Yes' %}
        Not Yes
      {% else %}
        Else
      {% endif %}
    ;;
  }

  dimension: returned_liquid_unless {
    type: yesno
    sql: ${returned_date} IS NOT NULL ;;
    html:
      {% unless value == 'Yes' %}
        Not Yes
      {% else %}
        Else
      {% endunless %}
    ;;
  }

  dimension: sale_price_liquid_and_test {
    type: string
    sql:  ${sale_price} ;;
    html: {% if returned._value == 'No' and value > 10 %}
          Inside If
          {% else %}
          Else
          {% endif %} ;;
  }

#   dimension: laura_murphy_liquid_test {
#     type: string
#     sql: ${sale_price}
#     html:
#     {% if value >= 1 and publisher_kpi_report.audience_development_referrers == 'Direct Home Page' %}
#     <div style="color: DarkGreen; background-color: #C6EFCE; text-align: right; font-weight: bold">
#     <img style="float: left" src="https://storage.googleapis.com/hnp_looker/arrow-up.png" />
#     {% elsif value >= 0.90 and publisher_kpi_report.audience_development_referrers == 'Direct Home Page' %}
#     <div style="color: DarkGoldenRod; background-color: #FFEB9C; text-align: right; font-weight: bold">
#     {% elsif value < 0.90 and publisher_kpi_report.audience_development_referrers == 'Direct Home Page' %}
#     <div style="color: DarkRed; background-color: #FFC7CE; text-align: right; font-weight: bold">
#     <img style="float: left" src="https://storage.googleapis.com/hnp_looker/arrow-down.png" />
#     {% endif %}
#     {{ rendered_value }}
#     </div>;;}

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
    html:
    {% if metric._parameter_value == 'usd' %}
     ${{ rendered_value | round: 3}}
    {% elsif metric._parameter_value == 'percent' %}
      {{ rendered_value }}%
    {% elsif metric._parameter_value == 'decimal' %}
      {{ rendered_value }}
    {% elsif metric._parameter_value == 'int' %}
      {{ rendered_value }}
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
