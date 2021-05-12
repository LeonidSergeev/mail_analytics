#!/usr/bin/env python
# coding: utf-8

# In[ ]:


from datetime import datetime
from array import *
import time
import requests
from requests.auth import AuthBase
 
 
class MyTrackerAuth(AuthBase):
    """Implements a authentication scheme."""
 
    def __init__(self, user, secret):
        self.user = user
        self.secret = secret
 
    def __call__(self, r):
        """Attach an Auth token to auth header."""
       
        r.headers['Authorization'] = 'AuthHMAC %s:%s' % (self.user, self.sign(r))
        return r
 
    def sign(self, r):
        """Generate auth request sign"""
       
        from urllib.parse import quote
        from hashlib import sha1
        import hmac
        import base64
 
        post_data = r.body if r.body else ''
        raw = "%s&%s&%s" % (r.method.upper(), quote(r.url, safe='~'), quote(post_data, safe='~'))
        hashed = hmac.new(
            bytearray(self.secret, 'utf-8'),
            bytearray(raw, 'utf-8'),
            sha1
        )
 
        return base64.b64encode(hashed.digest()).decode().rstrip('\n')
 

my_tracker_url = 'http://tracker.my.com/api/raw/v1/export/create.json'
my_tracker_user = '17652'
my_tracker_secret = 'G83tdeR6AA2HYfrsnRaaNHhr'

date_from = datetime.strptime("26/04/21 00:00", "%d/%m/%y %H:%M")
date_to = datetime.strptime("26/04/21 00:00", "%d/%m/%y %H:%M")
event = ['customEvents']
event_name = ["Play_track_to_end"]
SDKKey = ['89915556674342549710']
selectors = ['dtEvent','countCustomEvent','idAppVersionTitle','customUserId','idDevice','eventName','params.name','params.value']

params = {
    'dateFrom': date_from.strftime('%Y-%m-%d'),
    'dateTo': date_to.strftime('%Y-%m-%d'),
    'event': ','.join(event),    
    'SDKKey': ','.join(SDKKey),
    'selectors': ','.join(selectors),
    'eventName[]': event_name,
}
 
response = requests.get(
    my_tracker_url,
    auth=MyTrackerAuth(my_tracker_user, my_tracker_secret),
    params=params
)
 
print(response.json())
print(datetime.today())



track_id = response.json()["data"]["idRawExport"]
print(track_id)

my_tracker_url_get = 'https://tracker.my.com/api/raw/v1/export/get.json'
get_params = {
    'idRawExport': track_id
}
 
get_response = requests.get(
    my_tracker_url_get,
    auth=MyTrackerAuth(my_tracker_user, my_tracker_secret),
    params=get_params
)

print(get_response.json())

status = 'In progress'
while status == 'In progress':
    data = requests.get(
      my_tracker_url_get,
      auth=MyTrackerAuth(my_tracker_user, my_tracker_secret),
      params=get_params
    ).json()["data"]
    status=data["status"]
    time.sleep(4)
    if status=='Success!':
      print(data["files"])
    else:
      print(data)



# In[ ]:





# In[ ]:




