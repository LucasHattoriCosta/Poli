library(RMySQL)

con <- dbConnect(MySQL(),
                 user = 'ipisani',
                 password = 'BRAntoE',
                 host = 'bi-prd.cngykqj4zje9.us-east-1.rds.amazonaws.com',
                 port = 3306,
                 dbname = "apu")

res <- dbSendQuery(con, "SELECT 
                   t2.main_domain,
                   t1.email_engagement_score,
                   t1.email_engagement_segment
                   FROM
                   003210_em_engagement_score AS t1
                   INNER JOIN
                   007310_active_contact_list AS t2 ON t1.email_address = t2.email_address
                
                   ;")


# fetching in chunks -- way too large data table
result <- list()
i = 1
result[[i]] <- dbFetch(res, n = 100000)
while(nrow(chunk <- dbFetch(res, n = 100000)) > 0){
  i <- i+1
  result[[i]] <- chunk
}
final <- do.call(rbind,result)
dbClearResult(res)
dbDisconnect(con)
