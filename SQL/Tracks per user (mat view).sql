SELECT sum(countCustomEvent) as streams, 
count(DISTINCT idDevice) as users,
sum(countCustomEvent) / count(DISTINCT idDevice)  as tracks_per_user,
dtEvent,
idPlatformTitle,
subscriptionType as sub
FROM moosic_analytics.play_track_to_end
WHERE idAppVersionTitle LIKE '5.%'
AND subscriptionType in ('active','none')
GROUP BY dtEvent,idPlatformTitle, sub
ORDER BY idPlatformTitle, dtEvent