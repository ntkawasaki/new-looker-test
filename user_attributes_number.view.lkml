view: user_attributes_number {
  derived_table: {
    sql:
    SELECT * FROM orders
--     WHERE id = {{ _user_attributes['jtao_test']}}
    WHERE {% condition number %} id {% endcondition %}














    ;;
  }

  filter: number {
    type: number
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

}
