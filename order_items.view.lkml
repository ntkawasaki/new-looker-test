view: order_items {
  sql_table_name: demo_db.order_items;;

  parameter: yesno_tester {
    type: yesno
  }

  dimension: yesno_tester_dimension {
    type: string
    sql: {% if yesno_tester._parameter_value %}
          "RETURNED TRUE"
         {% endif %}
          "RETURNED FALSE"
          ;;
  }

  dimension: from_order_liquid {
    type: string
    sql: "{{ orders.from_orders._parameter_value }}" ;;
  }

  parameter: string_param {
    type: string
  }

  dimension: string_param_test {
    type: string
    sql: {% parameter string_param %} ;;
  }

  filter: string_filter {
    type: string
    suggest_dimension: orders.status
  }

  filter: date_filter {
    type: date
  }

  filter: date_time_filter {
    type: date_time
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: left_id {
    type: number
    sql: ${TABLE}.id ;;
    html: <p style="text-align: left">{{value}}</p> ;;
  }

  dimension: id_copy {
    type: number
    sql: ${TABLE}.id ;;
    html:
      {% assign threshold_number = threshold._parameter_value | plus: 0 %}
      {% if value > threshold_number %}
        "GREATER"
      {% else %}
        "LOWER"
      {% endif %}
    ;;
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
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: returned {
    type: yesno
    sql: ${returned_date} IS NOT NULL ;;
  }

  dimension: returned_url {
    type: string
    sql: COALESCE(${TABLE}.returned_at, 'THIS IS NULL') ;;
    link: {
      url: "{% unless value == 'THIS IS NULL'%}www.google.com/{{value}}{% endunless %}"
      label: "hi"
    }
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

  dimension: sale_price_brazilian {
    type: number
    sql:  ${sale_price} ;;
#     value_format: "\R$0\,00"
#     value_format_name: brazilian
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
#     sql: 'xxxyyyzzz' ;;
    link: {
      url: "{% unless value == 'xxxyyyzzz'%}www.google.com/{{value}}{% endunless %}"
    }
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

  # FROM LAURENS CHAT
  parameter: threshold {
    type: number
    default_value: "10"
  }

  measure: plus_minus_count {
    type: count
    link: {
      label: "Explore Within Threshold: ({{low}}, {{high}})"
      url: "{% assign low = value | minus: threshold._parameter_value %}{% assign high = value | plus: threshold._parameter_value %}/explore/hello_world/order_items?fields=orders.created_month,order_items.plus_minus_count,&f[order_items.count]={{low}} to {{high}}"
    }
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price};;
    value_format_name: usd
  }
#
#   measure: dynamic_total_sale_price_by_status {
#     type: number
#     sql: SUM(CASE WHEN  ;;
#   }

  parameter: dynamic_status {
    type: string
    suggest_dimension: orders.status
  }

#   measure: percent_of_total_sale_price {
#     type: percent_of_total
#     sql: ${total_sale_price} ;;
#     filters: {
#       field: orders.status
#       value: "pending"
#     }
#   }

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
    drill_fields: [order_id]
    sql: ${sale_price} ;;
    html: {{link}} ;;
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
    label: "Average Sale\'s"
    type: average
    sql: ${sale_price} ;;
  }

  measure: negative_sum_sale_price {
    type: sum
    sql: ${sale_price} - 3000 ;;
  }
}
