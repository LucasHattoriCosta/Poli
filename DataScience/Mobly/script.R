setwd("C:/Users/ivan.pisani/Desktop/Nova pasta/XML")
library(XML)



doc <- xmlTreeParse("feed_20160408.xml", useInternal=TRUE)
rootnode <- xmlRoot(doc)

id <- xpathSApply(rootnode,"//id",xmlValue)
url <- xpathSApply(rootnode,"//config_url",xmlValue)
price <- (xpathSApply(rootnode,"//price",xmlValue))
para <- (xpathSApply(rootnode,"//sale_price",xmlValue))
product_category <- xpathSApply(rootnode,"//product_category",xmlValue)
product_type <- xpathSApply(rootnode,"//product_type",xmlValue)
tier <- xpathSApply(rootnode, "//brand", xmlValue)
category <- xpathSApply(rootnode, "//product_type", xmlValue)
score <- as.numeric(xpathSApply(rootnode, "//Scoring", xmlValue))
porcentagem <- (price-para)/price
para <- gsub(" BRL","", para)
para <- as.numeric(gsub(",", ".", para))
t <- tapply(para,product_type, mean)
t <- t[order(-t)]

id <- id[tier == ""]
tier <- tier[tier == ""]
df <- data.frame(id, tier, stringsAsFactors = FALSE)
write.csv2(df, file = "Tiers_20160405.csv")

menor <- order(price)
maior <-order(price,decreasing=TRUE)
p_maior <- order(porcentagem,decreasing=TRUE)

url[menor[1]]
url[maior[1]]


# teste <- read.table("uploadts-1452546744-sec_pla_ca_googleshopping.txt", sep = "\t", fill = TRUE, quote = "", stringsAsFactors = FALSE, header = TRUE)
# c <- 1:44
# names(teste) <- c
# df <- data.frame(teste$`1`, teste$`40`)
# write.csv2(df, file = "tiers.csv")
