connection: "thelook"

include: "*.view.lkml"
include: "base.other.lkml"
# include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

explore: child_products {
  hidden: yes
  extends: [parent_products]
}

view: view_name {
  derived_table: {
    sql:
    {% assign tables = "pdt_1.SQL_TABLE_NAME, pdt_2.SQL_TABLE_NAME, pdt_3.SQL_TABLE_NAME" | split ", " %}

    {% for table in tables %}
    SELECT * FROM {{ table }} UNION ALL
    {% endfor %}
;;
  }
}
