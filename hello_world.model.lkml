connection: "thelook"

include: "*.view"

datagroup: hello_world_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}
week_start_day: monday

persist_with: hello_world_default_datagroup

explore: view_name_in_query {
  from: orders
  sql_always_where:
  {% if users._in_query %}
    users.age > 40
  {% else %}
    1=1
  {% endif %}
  --"{{users._in_query}}"
  ;;
  always_filter: {
    filters: {
      field: view_name_in_query.status
      value: "-pending, -completed"
    }
  }

  join: users {
    type: left_outer
    sql_on: ${view_name_in_query.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
#   sql_always_where:
#     {% if order_items.order_id._in_query or order_items.inventory_item_id._in_query %}
#     "IT WORKED" = "IT WORKED"
#     {% else %}
#     "ELSE" = "ELSE"
#     {% endif %} ;;

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

# explore: explore_name {
#
#   join: channel {
#     relationship: one_to_many
#     sql_on:
#           ${channel.idChannel} =
#         {% if statistics_daily_by_video._in_query %}
#           ${statistics_daily_by_video.channelId}
#         {% elsif statistics_daily_by_user_agent._in_query %}
#           ${statistics_daily_by_user_agent.channelId}
#
#         -- Can add it additional joins if needed
#
#         {% endif %} ;;
#   }
# }

explore: order_items_2 {
  from: order_items
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items_2.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items_2.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

# explore: orders {
#   join: users {
#     type: left_outer
#     sql_on: ${orders.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }

explore: products {
  always_filter: {
    filters: {
      field: brand
      value: ""
    }
  }
}

explore: schema_migrations {}

explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  access_filter: {
    field: users.first_name
    user_attribute: test_attribute
  }
}

explore: users {}

# named_value_format: brazilian {
#   value_format: "\R$ 0\,00"
# }

explore: user_summary {}

explore: test_select_all {}
