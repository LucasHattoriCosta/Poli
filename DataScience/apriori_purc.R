library("arules")
library("stringr")
library("recommenderlab")
fn <- unique(final)
spt <- split(fn$sku_config, fn$fk_customer)
txn <- as(spt, "itemMatrix")
txn <- as(txn, "transactions")

setwd("/opt/pentaho/files_csv/mkt_crm/reglog/")
file = read.csv("reg_purchase_output.csv", sep=";")


txn = as(as.matrix(file[,c(3:74)]), "transactions")
basket_rules <- apriori(txn,parameter = list(sup = 0.000336, conf = 0.005,target="rules", maxlen=2, minlen=2))
basket_rules <- sort(basket_rules, decreasing = TRUE, by = "support")
inspect(basket_rules[1:200])
basket<-as(basket_rules, "data.frame")

basket$left <- sapply(strsplit(as.character(basket$rules), "\\} => \\{"), "[", 1)
basket$right <- sapply(strsplit(as.character(basket$rules), "\\} => \\{"), "[", 2)
basket$left <- sapply(strsplit(as.character(basket$left), "\\{"), "[", 2)
basket$right <- sapply(strsplit(as.character(basket$right), "\\}"), "[", 1)

conf <- basket[c("left", "right", "confidence")]

conf$left <- as.numeric(str_replace_all(string = conf$left, pattern = "p_cat", replacement = ""))
conf$right <- as.numeric(str_replace_all(string = conf$right, pattern = "p_cat", replacement = ""))

id <- file[,1]
purc <- file[,3:74]
conf_matrix <- matrix(0,72,72)
prob_matrix <- matrix (0,nrow(purc),72)
prob_matrix2 <- matrix (0,nrow(purc),72)

for (k in 1:nrow(conf)){
  conf_matrix[conf[k,1],conf[k,2]] <- conf[k,3]
} 

for (i in 1:nrow(purc)){
  for (j in 1:ncol(purc)){
    if (purc[i,j] == 1){
      for (k in 1:72){
          prob_matrix[i,k] = prob_matrix[i,k] + conf_matrix[j,k]
      }
    }
  }
}

for (i in 1:nrow(purc)){
  for (j in 1:ncol(purc)){
    prob_matrix[i,j] = prob_matrix[i,j]/0.1
  }
}

prob_matrix <- cbind(id, prob_matrix)

write.table(prob_matrix, file = "outputconf_purc.csv", sep = ";", eol = "\n", dec = ",", col.names=FALSE, row.names=FALSE)

