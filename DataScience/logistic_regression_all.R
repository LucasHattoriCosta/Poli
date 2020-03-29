######## input navegação, compra e sexo, output compra

file = read.csv("/opt/pentaho/files_csv/mkt_crm/reglog/reg_all_output.csv", sep=";")
id_train <- file[,1]
input_train = file[,2:146]
output_train = file[,75:146]
prob_matrix <- matrix(0,nrow(input_train),ncol(output_train))

for (i in 1:ncol(output_train)){
  a <- output_train[,i]
  k <- i+73
  glm.out = glm(a~ ., family = binomial(logit), data = input_train[,-k])
  glm.probs = predict(glm.out,input_train[,-k] ,type ="response")
  prob_matrix[,i]=glm.probs/mean(file[,k+1])
}

prob_matrix <-cbind(id_train, prob_matrix)
write.table(prob_matrix, file = "/opt/pentaho/files_csv/mkt_crm/reglog/glm_nav_pur.csv", sep = ";", eol = "\n", dec = ",", col.names=FALSE, row.names=FALSE)
