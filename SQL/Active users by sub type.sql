SELECT count(DISTINCT user_id)
FROM 

(
    SELECT 
     customUserId
    FROM moosic_analytics.play_track_to_end
    WHERE subscriptionType = 'active' 
    AND idAppVersionTitle LIKE '5.%'
    AND dtEvent >= '2021-03-01'
    AND dtEvent < '2021-04-01'
    AND idPlatformTitle = 'iOS'
    GROUP BY customUserId
) as a

JOIN

(
select 
    user_id,provider
    FROM moosic_analytics.moosic_billing_stat
    WHERE action != 'canceled'
    AND action_date < end_date
    AND is_trial = '0'
    AND action_date >= '2021-03-01'
    AND action_date < '2021-04-01'
    group by user_id,provider
) as b

on a.customUserId = b.user_id
