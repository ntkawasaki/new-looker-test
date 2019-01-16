connection: "thelook"

# include all the views
# include: "*.view"

datagroup: hello_world_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: hello_world_default_datagroup
