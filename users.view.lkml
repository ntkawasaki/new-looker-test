view: users {
  sql_table_name: demo_db.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  parameter: country_param {
    type: string
    allowed_value: {
      label: "United States"
      value: "United States"
    }
    allowed_value: {
      label: "All"
      value: "All"
    }
  }

#   FROM
#   {% if country_param._parameter_value == 'United States' %}
#   table_1
#   {% else %}
#   table_2
#   {% endif %}

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
    suggest_dimension: email
  }

  dimension: full_name {
    type: string
    sql: CONCAT(${first_name}, " ", ${last_name}) ;;
  }


  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
#     link: {
#       label: "{{value}}"
#       url: "https://google.com/
#       newline/{{value}}"
#     }
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      first_name,
      last_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
