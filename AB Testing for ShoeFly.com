
#ad_clicks['is_click'] = ~ad_clicks\
#   .ad_click_timestamp.isnull()
#The ~ is a NOT operator, and isnull() tests whether or not the value of ad_click_timestamp is null.

