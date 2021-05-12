    SELECT dtEvent
    ,count(distinct idDevice) as usr
    ,sum(toFloat64(correct_duration)) as total_duration
    ,max(toFloat64(correct_duration)) as max_time_per_user_per_day
    ,total_duration / usr as time_per_user_per_day
    ,total_duration / usr / 60 as time_per_user_per_day_min
    ,avg(toFloat64(track_duration)) as avg_track_duration
    ,avg(toFloat64(duration)) as avg_stream_duration
    FROM 
        (
            SELECT countCustomEvent as streams, 
                   idDevice,
                   dtEvent,
                   eventName,
                   params['subscription_type'] as sub,
                   params['duration'] as duration,
                   params['track_duration'] as track_duration,
                   IF(toInt32(duration)>toInt32(track_duration), track_duration,duration) as correct_duration
            FROM moosic_analytics.mytracker_custom_events
            WHERE eventName = 'Play_track_to_end'
            AND params['subscription_type'] = 'active'
            AND idPlatformTitle = 'iOS'
            AND params['track_duration'] != ''
            AND params['duration'] != ''
            AND idAppVersionTitle LIKE '5.%'
            AND dtEvent = '2021-04-10'
        ) a
    GROUP BY dtEvent