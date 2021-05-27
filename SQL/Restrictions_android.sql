SELECT count(*)
,dtEvent
       FROM moosic_analytics.mytracker_custom_events
    WHERE 
    eventName in ('Purchase_cache','Purchase_background','Purchase_audio_adv','Purchase_restricted','Purchase_banner','Purchase_profile','Purchase_feed','Purchase_special_project','Track_region_restricted')
    AND idAppVersionTitle LIKE '5.1%'
    AND dtEvent >= '2021-05-21'
    AND idPlatformTitle = 'Android'
    group by dtEvent