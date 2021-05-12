select count(distinct user_id)
    ,count(*)
    ,provider
    ,concat (toString (toYear(action_date)),'-',toString(toMonth(action_date))) as date
    FROM moosic_analytics.moosic_billing_stat
    WHERE action != 'canceled'
    AND provider = 'googleplay'
    AND end_date > action_date 
    AND is_trial = '0'
    AND action_date < end_date
    group by provider,date
    order by date