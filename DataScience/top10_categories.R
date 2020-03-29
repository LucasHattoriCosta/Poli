file_path <- "/opt/pentaho/files_csv/mkt_crm/reglog/"

nav_pur_input<-read.table(paste(file_path,"glm_nav_pur.csv",sep=""),sep = ";",dec=",",quote="",header=FALSE)
nav_input<-read.table(paste(file_path,"glm_nav.csv",sep=""),sep = ";",dec=",",quote="",header=FALSE)
pur_input<-read.table(paste(file_path,"outputconf_purc.csv",sep=""),sep = ";",dec=",",quote="",header=FALSE)

input <- rbind(nav_pur_input, nav_input, pur_input)
ids<-input$V1
input <- input[,2:ncol(input)]
top_matrix <- matrix (0,nrow(input),10)

input[,49] <- 0

for (i in 1:nrow(input)){
  top_cat <- order(input[i,], decreasing=TRUE)[1:10]
  top_matrix[i,] <- top_cat
}

top_matrix <- cbind(ids, top_matrix)

colnames(top_matrix) <- c("id_responsys", "cat01", "cat02", "cat03", "cat04", "cat05", "cat06", "cat07", "cat08", "cat09", "cat10")

write.table(top_matrix, file = paste(file_path, "reglog_topcat.csv", sep=""), sep = ";", row.names = FALSE, col.names = TRUE)

