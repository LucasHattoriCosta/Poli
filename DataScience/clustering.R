setwd("C:/Users/ivan.pisani/Desktop/Cluster")

library(RMySQL)

con <- dbConnect(MySQL(),
                 user = 'ipisani',
                 password = 'BRAntoE',
                 host = 'bi-prd.cngykqj4zje9.us-east-1.rds.amazonaws.com',
                 port = 3306,
                 dbname = "apu")

res <- dbSendQuery(con, "select * from 007310_etnographic_clustering
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

#transforming data into factors
backup <- final
backup$lead_capture_source <- as.factor(backup$lead_capture_source)
backup$customer_type <- as.factor(backup$customer_type)
backup$customer_age <- as.factor(backup$customer_age)
backup$customer_gender <- as.factor(backup$customer_gender)
backup$acronym_state <- as.factor(backup$acronym_state)
backup$capital_countryside <- as.factor(backup$capital_countryside)
backup$last_channel_group <- as.factor(backup$last_channel_group)
backup$last_payment_method <- as.factor(backup$last_payment_method)
backup$buyer_repurchaser <- as.factor(backup$buyer_repurchaser)
backup$top_anchor_1 <- as.factor(backup$top_anchor_1)
backup$top_anchor_2 <- as.factor(backup$top_anchor_2)
backup$top_anchor_3 <- as.factor(backup$top_anchor_3)
backup$environment_type <- as.factor(backup$environment_type)

#extracting data that will be used in cluster analysis
base_cluster <- backup[,c("email_address","lead_capture_source", "customer_type", "customer_age",
                          "customer_gender", "acronym_state", "capital_countryside",
                          "last_channel_group", "last_payment_method", "buyer_repurchaser",
                          "top_anchor_1", "top_anchor_2", "top_anchor_3")]
base_cluster[300000:300005,]

#k-means clustering
set.seed(212)
mydata <- base_cluster[,2:13]
mysample <- mydata[sample(1:nrow(mydata), 10000,replace=FALSE),]

library("cluster")
library("bigmemory")
library("biganalytics")
dissimilarity_matrix <- daisy(mysample)
clusters <- kmeans(dissimilarity_matrix,4)
