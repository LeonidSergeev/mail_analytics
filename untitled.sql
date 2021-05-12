    SELECT dtEvent
    ,idPlatformTitle
    ,count(distinct idDevice) as usr
    ,sum(toFloat64(duration)) as total_duration
    ,total_duration / usr as time_per_user_per_day
    ,sub
    FROM 
        (
            SELECT countCustomEvent as streams, 
                   idDevice,
                   dtEvent,
                   idPlatformTitle,
                   subscriptionType as sub,
                   progress as progress,
                   toFloat64(progress) / 100 * 200 * streams as duration
            FROM moosic_analytics.play_track_to_end
            WHERE idAppVersionTitle LIKE '5.%'
            AND subscriptionType in ('active','none')
            AND dtEvent >= '2021-04-20'
        )
    GROUP BY dtEvent,idPlatformTitle,sub
    ORDER BY dtEvent
    
    
