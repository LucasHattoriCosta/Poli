library(RMySQL)

con <- dbConnect(MySQL(),
                 user = 'ipisani',
                 password = 'BRAntoE',
                 host = 'bi-prd.cngykqj4zje9.us-east-1.rds.amazonaws.com',
                 port = 3306,
                 dbname = "apu")

res <- dbSendQuery(con, "select
 fk_customer,
   sku_config
from
 apu.003200_sales_pl pl
join
 apu.003000_date d on d.tk_date = pl.fk_date_created
join
 apu.003010_portfolio_static ps on ps.tk_portfolio_static = pl.fk_portfolio_static
where
 date >= curdate() - interval 15 day

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


#tratamento de dados para começo do algoritmo de recom
library("arules")
library("stringr")
library("recommenderlab")
fn <- unique(final)
spt <- split(fn$sku_config, fn$fk_customer)
txn <- as(spt, "itemMatrix")
real <- as(txn, "binaryRatingMatrix")

#recomendação

#rec<-Recommender(real[1:nrow(real)],method="UBCF", param=list(normalize = "Z-score",method="Cosine",nn=5, minRating=1))
#rec<-Recommender(real[1:nrow(real)],method="UBCF", param=list(normalize = "Z-score",method="Jaccard",nn=5, minRating=1))
#rec<-Recommender(real[1:nrow(r)],method="IBCF", param=list(normalize = "Z-score",method="Jaccard",minRating=1))
#rec<-Recommender(r[1:nrow(r)],method="POPULAR")
rec <- Recommender(real,method="UBCF", param = list(method = "Jaccard", normalize = 'Z-score', nn=5, minRating=1))
recom <- predict(rec, real[2,], n = 3)
as(recom, "list")

rec2 <- Recommender(real[1:nrow(real)],method="POPULAR")
recom2 <- predict(rec2, real[1,], n = 3, type = "topNList")
as(recom2,"list")





