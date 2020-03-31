setwd("C:/Users/ivan.pisani/Desktop/Nova pasta/R/randomforest")

library(RMySQL)

con <- dbConnect(MySQL(),
                 user = 'ipisani',
                 password = 'BRAntoE',
                 host = 'bi-prd.cngykqj4zje9.us-east-1.rds.amazonaws.com',
                 port = 3306,
                 dbname = "apu")

res <- dbSendQuery(con, "SELECT 
    ees.email_address,
    ees.email_engagement_segment,
    acl.date_customer_since,
    acl.main_domain,
    acl.lead_source,
    acl.customer_type,
    acl.gender,
    acl.age,
    acl.acronym_state,
    dt.year AS ano_cadastro,
    dt.month_name AS mes_cadastro
FROM
    003210_em_engagement_score AS ees
        LEFT JOIN
    007310_active_contact_list AS acl ON ees.email_address = acl.email_address
        LEFT JOIN
    003210_rfm_mobly AS rfm ON ees.email_address = rfm.email_address
        LEFT JOIN
    003000_date AS dt ON ees.fk_date_first_launch = dt.tk_date
WHERE
    ees.calc_year_week = '2016/05'
        AND rfm.year_week_calc = '2016/05'
                
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



######### tratamento dos dados para posterior análise
trt <- final
trt$email_engagement_segment <- as.factor(trt$email_engagement_segment)
trt$main_domain[is.na(trt$main_domain)] <- "others"
trt$main_domain <- as.factor(trt$main_domain)
trt$lead_source[is.na(trt$lead_source)] <- "unknown"
trt$lead_source <- as.factor(trt$lead_source)
trt$customer_type[is.na(trt$customer_type)] <- "unknown"
trt$customer_type <- as.factor(trt$customer_type)
trt$gender[is.na(trt$gender)] <- "unknown"
trt$gender <- as.factor(trt$gender)
trt$ano_cadastro <- as.factor(trt$ano_cadastro)
trt$mes_cadastro <- as.factor(trt$mes_cadastro)
trt$acronym_state[is.na(trt$acronym_state)] <- "unknown"
trt$acronym_state <- as.factor(trt$acronym_state)
trt$age[is.na(trt$age)] <- mean(trt$age[trt$age > 0], na.rm = TRUE)
trt$age[trt$age == 0] <- mean(trt$age[trt$age >0], na.rm = TRUE)
trt$date_customer_since <- as.Date(trt$date_customer_since)

library(lubridate)
trt$customer_month <- month(trt$date_customer_since)
trt$customer_year <- year(trt$date_customer_since)
trt$buyer <- NA
trt$buyer[is.na(trt$customer_month)] <- 0
trt$buyer[!is.na(trt$customer_month)] <- 1
trt$buyer_last_week <- 0
trt$buyer_last_week[trt$customer_month == 1 & trt$customer_year == 2016] <- 1

trt$customer_month <- as.factor(trt$customer_month)
trt$customer_year <- as.factor(trt$customer_year)

#separando em train e test set
train <- trt[1:300000,]
test <- trt[(length(train$email_address)+1):length(trt$email_address),]
resposta_certa <- test$buyer_last_week
test <- test[,1:14]

library(rpart)
library(rattle)
library(rpart.plot)

set.seed(4)
fit <- rpart(buyer_last_week ~email_engagement_segment + main_domain
             + lead_source + customer_type + gender + age + acronym_state
             + ano_cadastro + mes_cadastro, data = train, method = "class")
fancyRpartPlot(fit)

prediction <- predict(fit, test, type = "class")

verify <- data.frame(resposta_certa, pred = as.numeric(prediction))
verify$pred[verify$pred == 1] <- 0
verify$pred[verify$pred == 2] <- 1
verify$correct <- 0
verify$correct[verify$resposta_certa == verify$pred] <- 1
sum(verify$correct)/ length(verify$correct)


library(randomForest)
fit2 <- randomForest(as.factor(buyer_last_week) ~ email_engagement_segment + main_domain
              + lead_source + customer_type + gender + age + acronym_state
              + ano_cadastro + mes_cadastro, data = train, importance = TRUE, ntree = 100)
varImpPlot(fit2)
prediction2 <- predict(fit2, test)
verify2 <- data.frame(resposta_certa, pred = as.numeric(prediction2))
verify2$pred[verify2$pred == 1] <- 0
verify2$pred[verify2$pred == 2] <- 1
verify2$correct <- 0
verify2$correct[verify2$resposta_certa == verify2$pred] <- 1
sum(verify$correct)/ length(verify$correct)
