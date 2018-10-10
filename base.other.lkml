connection: "thelook"

include: "*.view.lkml"                       # include all views in this project

# Some base explore to be extended through other models
explore: parent_products {
  from: products
}
