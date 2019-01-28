view: orders {
  sql_table_name: demo_db.orders ;;

  parameter: date_granularity {
    allowed_value: {
      label: "Week"
      value: "Week"
    }
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  parameter: dimension_selector {
    type: unquoted
    allowed_value: {
      label: "Option 1"
      value: "option_1"
    }

    allowed_value: {
      label: "Option 2"
      value: "option_2"
    }
  }

  parameter: sub_dimension_selector {
    type: unquoted
    allowed_value: {
      label: "Sub Option 1"
      value: "sub_option_1"
    }

    allowed_value: {
      label: "Sub Option 2"
      value: "sub_option_2"
    }
  }

  dimension: string_id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: selector_dimension {
    type: string
    sql:
    -- Print liquid variables
    -- Dimension Selector: {{ dimension_selector._parameter_value }}
    -- Sub Dimension Selector: {{ sub_dimension_selector._parameter_value }}
    -- String ID In Query: {{ string_id._in_query }}

    {% if dimension_selector._parameter_value == 'option_1' and sub_dimension_selector._parameter_value == 'sub_option_1' %}
        "IF EXECUTED"
    {% elsif dimension_selector._parameter_value == 'option_1' and
       sub_dimension_selector._parameter_value == 'sub_option_2' and
       string_id._in_query == false
    %}
        "ELSIF EXECUTED"
    {% else %}
        "ELSE EXECUTED"
    {% endif %}
    ;;
  }



  dimension: id_link_test {
    type: number
    sql: ${TABLE}.id ;;
    html: {{linked_value}} ;;
    link: {
      label: "Hi"
      url: "www.google.com"
    }
  }

  parameter: from_orders {
    type: string
    suggest_dimension: orders.status
  }

  dimension_group: created {
    type: time
    timeframes: [
    ]
    sql: ${TABLE}.created_at ;;
  }

  parameter: quarter_parameter {
    type: string
  }

  dimension: is_quarter_parameter {
    type: yesno
    sql: ${created_quarter} = {% parameter quarter_parameter %} ;;
  }


  dimension: c_or_p {
    type: string
    sql:
      CASE
        WHEN (${created_raw} > "2017-10-01" THEN "C")
        WHEN (${created_raw} < "2017-10-01" AND ${created_raw} > "2016-10-01") THEN "P"
      END
    ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: sql_case {
    type: string
    sql:
    CASE
      WHEN ${status} like "%a%" THEN 'Has Vowel'
      WHEN ${status} like "%b%" THEN 'Has Consonant'
      WHEN ${status} like "%e%" THEN 'Has Vowel'
      WHEN ${status} like "%c%" THEN 'Has Consonant'
      ELSE 'Neither'
    END
    ;;
  }

  dimension: lookml_case {
    type: string
    case: {
      when: {
        label: "Has Vowel"
        sql: ${status} like "%a%" ;;
      }

      when: {
        label: "Has Consonant"
        sql: ${status} like "%b%" ;;
      }

      when: {
        label: "Has Vowel"
        sql: ${status} like "%e%" ;;
      }

      when: {
        label: "Has Consonant"
        sql: ${status} like "%c%" ;;
      }

      else: "Neither"

    }
  }

  dimension: new_status {
    type: string
    sql: ${status} ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.first_name, users.last_name, users.id, order_items.count]
  }

  measure: negative_count {
    type: count
  }

  measure: count_divided {
    type: number
    sql: COUNT(*)/4000 ;;
  }

  measure: count_without_liquid_link {
    type: count
  }

  measure: count_with_liquid_link {
    type: count
    link: {
      label: "Hello World!"
      url: "https://www.google.com/search?q={{ status._value }}"
    }
  }

  measure: completed_count {
    type: count
    filters: {
      field: status
      value: "completed"
    }
  }

  measure: pending_count {
    type: count
    filters: {
      field: status
      value: "pending"
    }
  }




  measure: completed_over_pending {
    type: number
    sql: ${completed_count} / COALESCE(${pending_count}, 0) ;;
    html: {{ value | round: 1 }} ;;
  }

  measure: cancelled_count {
    type: count
    filters: {
      field: status
      value: "cancelled"
    }
  }


}
