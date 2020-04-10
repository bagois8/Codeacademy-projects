
#ad_clicks['is_click'] = ~ad_clicks\
#   .ad_click_timestamp.isnull()
#The ~ is a NOT operator, and isnull() tests whether or not the value of ad_click_timestamp is null.

import codecademylib
import pandas as pd

ad_clicks = pd.read_csv('ad_clicks.csv')

print(ad_clicks.head(10))

print(ad_clicks\
.groupby('utm_source')\
.user_id.count().reset_index())


ad_clicks['is_click'] = ~ad_clicks\
.ad_click_timestamp.isnull()

print(ad_clicks.head(10))

clicks_by_source = ad_clicks\
.groupby(['utm_source','is_click'])\
.user_id.count()\
.reset_index()

print(clicks_by_source)

clicks_pivot = clicks_by_source.pivot(
  columns='is_click',
  index='utm_source',
  values='user_id'
).reset_index()

print(clicks_pivot)

clicks_pivot['percent_clicked'] = \
clicks_pivot[True]/(clicks_pivot[True]+clicks_pivot[False])

print(clicks_pivot)


print(
  ad_clicks\
.groupby(['experimental_group'])\
.user_id.count()\
.reset_index()
)


AB_source = ad_clicks\
.groupby(['experimental_group','is_click'])\
.user_id.count()\
.reset_index()

AB_pivot = AB_source.pivot(
  columns='is_click',
  index='experimental_group',
  values='user_id'
).reset_index()


AB_pivot['percent_clicked'] = \
AB_pivot[True]/(AB_pivot[True]+AB_pivot[False])

print(AB_pivot)


a_clicks = ad_clicks[ad_clicks.experimental_group == 'A']
print(a_clicks)
b_clicks = ad_clicks[ad_clicks.experimental_group == 'B']
print(b_clicks)


a_clicks_pivot = a_clicks\
.groupby(['is_click','day'])\
.user_id.count()\
.reset_index()\
.pivot(
  columns='is_click',
  index='day',
  values='user_id'
).reset_index()
print(a_clicks_pivot)

b_clicks_pivot = b_clicks\
.groupby(['is_click','day'])\
.user_id.count()\
.reset_index()\
.pivot(
  columns='is_click',
  index='day',
  values='user_id'
).reset_index()
print(b_clicks_pivot)

a_clicks_pivot['perc_day_a'] = a_clicks_pivot[True]/(a_clicks_pivot[True]+a_clicks_pivot[False])

b_clicks_pivot['perc_day_b'] = b_clicks_pivot[True]/(b_clicks_pivot[True]+b_clicks_pivot[False])


print(a_clicks_pivot)
print(b_clicks_pivot)


