# From: https://looker.zendesk.com/agent/tickets/172957
view: order_product_selector {
  derived_table: {
    sql:
    SELECT
    *
    ,sum(price) over (partition by order_id) as product_a_check_price
    FROM

        (
        SELECT
        ch.check_key as order_id
        ,concat(cli.check_key,'~',cast(cli.ordinal as varchar)) as order_item_id
        ,cli.quantity
        ,ch.open_date_local as created_at
        ,'product' as product
        ,cli.price
        ,case when cli.price = 0 then TRUE else FALSE end as is_item_free
        ,ch.subtotal

        FROM
        check_summary ch
        JOIN check_detail cli
          ON ch.check_key = cli.check_key
        JOIN categories cc
          ON cli.check_key = cc.check_key AND cli.ordinal = cc.item_ordinal
        JOIN account act
          ON   act.account_key = ch.account_key
        JOIN store s
          ON ch.store_id = s.store_id
        LEFT OUTER JOIN campaign ca
          ON
            ca.account_key = ch.account_key AND
            ca.merchant_id = {{_user_attributes['merchant_id']}} AND
            ca.p_monthofyear >= DATE_FORMAT(COALESCE({% date_start affinity_timeframe %}, DATE_ADD('month', -6, NOW())), '%Y-%m')

        WHERE
          act.merchant_id = {{ _user_attributes['merchant_id']}} AND
          s.merchant_id = {{ _user_attributes['merchant_id']}} AND
          ch.merchant_id = {{ _user_attributes['merchant_id']}} AND
          cli.merchant_id = {{ _user_attributes['merchant_id']}} AND
          cc.merchant_id = {{ _user_attributes['merchant_id']}} AND

          {% condition affinity_timeframe %}    DATE(ch.open_date_local) {% endcondition %} AND
          {% condition item_id_filter %}        cli.item_id {% endcondition %} AND
          {% condition item_name_filter %}      cli.item_name {% endcondition %} AND
          {% condition category_id_filter %}    cc.category_id {% endcondition %} AND
          {% condition category_name_filter %}  cc.category_name {% endcondition %} AND
          {% condition item_type %}             cli.item_type {% endcondition %} AND
          {% condition store_code %}            s.code {% endcondition %} AND
          {% condition store_name %}            s.name {% endcondition %} AND
          {% condition is_loyalty %}            act.is_loyalty {% endcondition %} AND
          {% condition is_registered %}         act.is_registered {% endcondition %} AND
          {% condition is_email_eligible %}     act.is_email_eligible {% endcondition %} AND
          {% condition loyalty_band_label %}    act.loyalty_band_label {% endcondition %} AND
          {% condition campaign_label %}        ca.campaign_label {% endcondition %} AND
          {% condition cell_type %}             ca.cell_type {% endcondition %} AND
          {% condition start_date %}            ca.start_date {% endcondition %}

        GROUP BY 1,2,3,4,5,6,7,8

        ) z

    WHERE
      {% condition is_item_free %} is_item_free {% endcondition %} ;;
  }

  filter: affinity_timeframe {type: date}
  filter: item_id_filter {type: string}
  filter: item_name_filter {type: string}
  filter: category_id_filter {type: string}
  filter: category_name_filter {type: string}
  filter: item_type {type: string}
  filter: store_code {type: string}
  filter: store_name {type: string}
  filter: is_loyalty {type: yesno}
  filter: is_registered {type: yesno}
  filter: is_email_eligible {type: yesno}
  filter: loyalty_band_label {type: string}
  filter: campaign_label {type: string}
  filter: cell_type {type: string}
  filter: start_date {type: string}
  filter: is_item_free {type: yesno}

}
