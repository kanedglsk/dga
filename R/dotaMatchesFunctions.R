#' @title Get history of all matches with 32bit Steam ID
#' @param accountId 32bit Steam ID
#' @param apiKey A api key string from https://steamcommunity.com/dev/apikey
#' @import httr
#' @import dplyr
#' @import jsonlite
#' @return data.frame of match records
#' @export
GetMatchHistoryAll <- function(accountId, apiKey) {
  if (missing(accountId)) {
    stop("accountId must be provided.")
  }
  if (missing(apiKey)) {
    stop("apiKey must be provided.")
  }
  matchList <- list()
  matchRESTURL <- sprintf("https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?account_id=%s&key=%s",
                          accountId, apiKey)
  JSONResult <- GET(matchRESTURL)
  resultList <- httr::content(JSONResult)
  matchList <- c(matchList, resultList$result$matches)

  isContinue <- TRUE
  while (isContinue) {
    lastEntry <- length(resultList$result$matches)
    lastMatchId <- resultList$result$matches[[lastEntry]]$match_id
    matchRESTURL <- sprintf("https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?account_id=%s&key=%s&start_at_match_id=%s",
                            accountId, apiKey, lastMatchId)
    # print(paste0("Searching ", matchRESTURL))
    JSONResult <- GET(matchRESTURL)
    resultList <- httr::content(JSONResult)
    matchList <- c(matchList, resultList$result$matches)

    if (resultList$result$num_results == 1) {
      isContinue <- FALSE
    }
  }

  matchHistory <- do.call(rbind, matchList) %>% as.data.frame
  matchHistory <- matchHistory %>% distinct
  print(paste0(nrow(matchHistory), " records are found."))
  return(matchHistory)
}
