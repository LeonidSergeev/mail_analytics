SELECT 
idPlatformTitle,
data.dtEvent,
sub,
count(distinct usr),
sum(streams) / count(distinct usr)


FROM

    (
    SELECT 
    idDevice as usr,
    dtEvent,
    subscriptionType as sub,
    idPlatformTitle,
    sum(countCustomEvent) as streams
    FROM moosic_analytics.play_track_to_end
    WHERE idAppVersionTitle LIKE '5.%'
    AND subscriptionType in ('active','none')
    AND dtEvent >= '2021-04-15'

    GROUP BY usr,dtEvent,sub,idPlatformTitle) as data

FULL OUTER JOIN

    (SELECT 
    idDevice,
    dtEvent
    FROM moosic_analytics.play_track_to_end
    WHERE 
    from in ('autoplay_mix_playlist','main_friends','main_mix_smart','main_recommendation_album','main_recommendation_artist','main_recommendation_playlist','main_recommendation_track','menu_mix_album','menu_mix_playlist','menu_mix_track','mix_album','mix_artist','mix_genre','mix_player_notification','mix_playlist','mix_select','mix_smart','menu_mix_artist')
    AND idAppVersionTitle LIKE '5.%'
    AND dtEvent >= '2021-04-15'
    GROUP BY idDevice, dtEvent) as sub

ON usr = sub.idDevice AND data.dtEvent = sub.dtEvent

WHERE sub.idDevice != ''

GROUP BY sub,data.dtEvent,idPlatformTitle
ORDER BY dtEvent,idPlatformTitle,sub