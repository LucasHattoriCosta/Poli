#Cluster RFM

# fetching data from db

library(RMySQL)

con <- dbConnect(MySQL(),
                 user = 'ipisani',
                 password = 'BRAntoE',
                 host = 'bi-prd.cngykqj4zje9.us-east-1.rds.amazonaws.com',
                 port = 3306,
                 dbname = "apu")

res <- dbSendQuery(con, "SELECT 
                              email_address,
                              dt.tk_date - fk_date_last_order AS recency,
                              delivered_orders as frequency,
                              avg_ticket_size as monetary
                         FROM
                              003210_rfm_mobly
                         JOIN 003000_date dt ON dt.date = CURDATE()
                         WHERE
                              year_week_calc = dt.year_week
                
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

#subsetting values to a RFM classification
#final$R <- as.integer(cut(-final$recency, quantile(-final$recency, prob = seq(0,1,0.2)), include.lowest = TRUE))
final$R[final$recency <= 90] <- 3
final$R[(final$recency > 90 & final$recency <= 365)] <- 2
final$R[final$recency > 365] <- 1
final$FREQ[final$frequency == 1] <- 1
final$FREQ[final$frequency == 2 || final$frequency == 3] <- 2
final$FREQ[final$frequency >= 4] <- 3
#final$M <- as.integer(cut(final$monetary, quantile(final$monetary, prob = seq(0,1,0.2)), include.lowest = TRUE))
final$M[final$monetary <= 577] <- 1
final$M[final$monetary > 577] <- 2
final$RFM <- final$R*100 + final$FREQ*10 + final$M
tapply(final$email_address, final$RFM, length)
tapply(final$email_address, final$RFM, length)/length(final$email_address)*100
tapply(final$recency, final$RFM, mean)


dataset <- data.frame(final$recency, final$delivered_orders, final$avg_ticket_size)
mysample <- dataset[sample(1:nrow(dataset), 15000, replace=FALSE),]
fit <- hclust(dist(mysample), method = "ward.D2")
plot(fit)

library(cluster)
sample.pam <- pam(mysample, 4)
