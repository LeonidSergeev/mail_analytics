    SELECT dtEvent
    ,idPlatformTitle
    ,sub
    ,count(distinct idDevice) as usr
    ,sum(toFloat64(duration)) as total_duration
    ,max(toFloat64(duration)) as max_time_per_user_per_day
    ,total_duration / usr as time_per_user_per_day
    FROM 
        (
            SELECT countCustomEvent as streams, 
                   idDevice,
                   dtEvent,
                   eventName,
                   idPlatformTitle,
                   params['subscription_type'] as sub,
                   params['progress'] as progress,
                   toFloat64(progress) / 100 * 200 * streams as duration
            FROM moosic_analytics.mytracker_custom_events
            WHERE eventName = 'Play_track_to_end'
            AND idAppVersionTitle LIKE '5.%'
            AND dtEvent = '2021-05-03'
            AND params['subscription_type'] in ('none','active')
            
        ) a
    GROUP BY dtEvent,idPlatformTitle,sub
    ORDER BY idPlatformTitle