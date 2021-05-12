SELECT count(DISTINCT old_usr)
FROM

    (
    SELECT 
    user_id as old_usr
    ,product_id 
    FROM moosic_analytics.moosic_billing_stat
    WHERE product_id  in ('boom_vk_money_vk','BASE','boom','BOOMVk','combo_android_notrial')
    AND is_trial = '0'
    AND toDate(action_date) >= '2021-01-01'
    AND toDate(action_date) < '2021-02-01'
    AND provider != 'vk'
    AND action_date < end_date
    AND action = 'reg'
    group by product_id,user_id
    ) old

FULL OUTER JOIN

    (
    SELECT distinct user_id as new_usr
    FROM moosic_analytics.moosic_billing_stat
    WHERE action = 'renew'
    AND action_date >= '2021-02-01'
    AND provider != 'vk'
    ) new
    
on old_usr = new_usr
WHERE new_usr != ''
AND product_id  != ''
