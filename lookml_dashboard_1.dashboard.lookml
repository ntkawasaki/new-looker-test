- dashboard: dashboard_1
  title: Dashboard 1
  layout: newspaper
  elements:
  - title: Orders by Month
    name: Orders by Month
    model: hello_world
    explore: order_items
    type: looker_column
    fields:
    - orders.created_month_name
    - orders.count
    fill_fields:
    - orders.created_month_name
    sorts:
    - orders.created_month_name
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    color_application:
      collection_id: legacy
      palette_id: green_to_red
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    point_style: none
    series_colors: {}
    series_types: {}
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    row: 0
    col: 0
    width: 15
    height: 6
  - name: Image
    type: text
    title_text: Image
    body_text: <img src="https://squirrel.ws/img/suits/gallery/freak2/gallery/4.jpg"
      />
    row: 0
    col: 15
    width: 9
    height: 15
  - title: Count by Brand
    name: Count by Brand
    model: hello_world
    explore: order_items
    type: table
    fields:
    - products.brand
    - products.count
    sorts:
    - products.count desc
    limit: 500
    column_limit: 50
    series_types: {}
    row: 6
    col: 0
    width: 15
    height: 8
