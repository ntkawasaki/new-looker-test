connection: "thelook"

include: "*.view.lkml"                       # include all views in this project

explore: order_items_conditional {
  from: order_items
  hidden: yes

  join: orders {
    type: left_outer
    sql_on: ${order_items_conditional.order_id} = ${orders.id}
      {% if orders.status._in_query %}
      AND 1=1
      {% endif %}
    ;;
    relationship: many_to_one
  }
}
