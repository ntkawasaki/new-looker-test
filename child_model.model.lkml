include: "*.view.lkml"
include: "base.other.lkml"
# include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

explore: child_products {
  extends: [parent_products]
}
