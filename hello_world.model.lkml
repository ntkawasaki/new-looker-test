connection: "thelook"

include: "*.view"

datagroup: hello_world_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: etl_users {
  sql_trigger: SELECT MAX(DATE(users.created_at)) FROM demo_db.users AS users ;;
  max_cache_age: "24 hours"
}

datagroup: etl_orders {
  sql_trigger: SELECT MAX(orders.id) FROM demo_db.orders  AS orders  ;;
  max_cache_age: "24 hours"
}

persist_with: hello_world_default_datagroup

explore: test_explore {
  hidden: yes
  from: orders
  sql_always_where:
  {% if users._in_query %}
    # users.age IS NOT NULL
  {% else %}
    1=1
  {% endif %}
  --"{{users._in_query}}"
  ;;
#   access_filter: {
#     field: status
#     user_attribute: my_status
#   }

  join: users {
    type: left_outer
    sql_on: ${test_explore.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  view_label: "1) Order Items"
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
#   access_filter: {
#     field: users.first_name
#     user_attribute: test_attribute
#   }
}

explore: users {}

# named_value_format: brazilian {
#   value_format: "\R$ 0\,00"
# }

explore: user_summary {}

explore: test_select_all {}
