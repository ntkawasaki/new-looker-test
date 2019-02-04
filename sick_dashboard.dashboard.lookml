- dashboard: sick_dashboard
  title: SICK DASHBOARD
  layout: newspaper
  elements:
  - title: New Tile
    name: New Tile
    model: system__activity
    explore: history
    type: looker_area
    fields:
    - user.count
    - history.completed_week
    fill_fields:
    - history.completed_week
    filters:
      history.completed_week: 6 weeks ago for 6 weeks
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: ''
    colors:
    - "#75E2E2"
    - "#3EB0D5"
    - "#4276BE"
    - "#462C9D"
    - "#9174F0"
    - "#B1399E"
    - "#B32F37"
    - "#E57947"
    - "#FBB555"
    - "#FFD95F"
    - "#C2DD67"
    - "#72D16D"
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
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    reference_lines:
    - reference_type: line
      line_value: mean
      range_start: max
      range_end: min
      margin_top: deviation
      margin_value: mean
      margin_bottom: deviation
      label_position: right
      color: "#B32F37"
      label: 'Avg: {{mean}}'
      value_format: 0.#
      __FILE: system__activity/user_activity.dashboard.lookml
      __LINE_NUM: 433
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    note_state: collapsed
    note_display: above
    note_text: Keep a pulse on general user activity
    row: 0
    col: 0
    width: 24
    height: 8
  - title: New stuff
    name: New stuff
    model: hello_world
    explore: order_items
    type: looker_line
    fields:
    - orders.count
    - orders.created_month_name
    - order_items.total_sale_price
    fill_fields:
    - orders.created_month_name
    sorts:
    - orders.created_month_name
    limit: 500
    query_timezone: America/Los_Angeles
    series_types: {}
    row: 8
    col: 0
    width: 8
    height: 6
