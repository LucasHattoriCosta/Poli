######## input navegação e sexo, output compra

file = read.csv("/opt/pentaho/files_csv/mkt_crm/reglog/reg_all_output.csv", sep=";")
id_train <- file[,1]
input_train = file[,2:74]
output_train = file[,75:146]
file2 = read.csv("/opt/pentaho/files_csv/mkt_crm/reglog/reg_navigation_output.csv", sep=";")
id_test <- file2[,1]
input_test <- file2[,2:74]
prob_matrix <- matrix(0,nrow(input_test),ncol(output_train))

for (i in 1:ncol(output_train)){
  a <- output_train[,i]
  glm.out = glm(a~ ., family = binomial(logit), data = input_train)
  glm.probs = predict(glm.out,input_test ,type ="response")
  prob_matrix[,i]=glm.probs/mean(output_train[,i])
}

prob_matrix <-cbind(id_test, prob_matrix)
write.table(prob_matrix, file = "/opt/pentaho/files_csv/mkt_crm/reglog/glm_nav.csv", sep = ";", eol = "\n", dec = ",", col.names=FALSE, row.names=FALSE)
