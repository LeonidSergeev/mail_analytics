SELECT count(DISTINCT old_usr),provider
FROM
    (
    SELECT 
    user_id as old_usr
    ,provider
    FROM moosic_analytics.moosic_billing_stat
    WHERE is_trial = '1'
    AND action = 'reg'
    AND toDate(action_date) >= '2021-01-01'
    AND toDate(action_date) < '2021-02-01'
    AND provider not in ('vk','ok')  
    AND action_date < end_date
    group by provider,user_id
    ) old
FULL OUTER JOIN
    (
    SELECT user_id as new_usr
    ,provider
    FROM moosic_analytics.moosic_billing_stat
    WHERE action = 'renew'
    AND provider not in ('vk','ok')  
    AND action_date < end_date
    group by provider,user_id
    ) new
on old_usr = new_usr
WHERE new_usr != ''
GROUP BY provider