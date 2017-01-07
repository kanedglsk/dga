# dga
Simple wrapper for getting match history

# Get an API key
Register on https://steamcommunity.com/dev/apikey.

# Get all match history from an account
```r
library(dga)
result <- GetMatchHistoryAll(accountId = accountId, #32bit steam id
                             apiKey = apiKey) #the API key you got
```
