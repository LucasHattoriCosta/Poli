setwd("C:/Users/ivan.pisani/Desktop/Nova pasta")

ra <- read.csv2("RepAnlAll.csv", stringsAsFactors = FALSE)

fo <- strsplit(ra$chave_1, ",")
fo <- sapply(fo, strsplit, split = "[*]", simplify = TRUE)

for (i in 1:length(fo)){
     fo[[i]] <- unlist(fo[[i]])
}

for (i in 1:length(fo)){
     fo[[i]] <- fo[[i]][seq(2,length(fo[[i]]),2)]
}
fo <- sapply(fo, unique)
indx <- sapply(fo, length)
res <- as.data.frame(do.call(rbind,lapply(fo, `length<-`, max(indx))), stringsAsFactors = FALSE)

so <- strsplit(ra$chave_2, ",")
so <- sapply(so, strsplit, split = "[*]", simplify = TRUE)

for (i in 1:length(so)){
     so[[i]] <- unlist(so[[i]])
}

for (i in 1:length(so)){
     so[[i]] <- so[[i]][seq(2,length(so[[i]]),2)]
}
so <- sapply(so, unique)
indx <- sapply(so, length)
res2 <- as.data.frame(do.call(rbind,lapply(so, `length<-`, max(indx))), stringsAsFactors = FALSE)

     mylist <- data.frame(x = res[,1], y = res2[,1], stringsAsFactors = FALSE)
for (i in 1:(length(res2)-1)) {
     apoio <- data.frame(x = res[,1],y =res2[,(i+1)], stringsAsFactors = FALSE)
     mylist <- rbind(mylist,apoio)
     mylist <- mylist[(!is.na(mylist$x) & !is.na(mylist$y)),]
}

 
for (i in 2:length(res)){
     for(j in 1:length(res2)){
          apoio <- data.frame(x = res[,i], y = res2[,j], stringsAsFactors = FALSE)
          mylist <- rbind(mylist, apoio)
          mylist <- mylist[(!is.na(mylist$x) & !is.na(mylist$y)),]
     }
}     
     

dupl <- mylist              
dupl$x <- as.factor(dupl$x)
dupl$y <- as.factor(dupl$y)
mytable <- table(dupl$x, dupl$y)
write.csv2(mytable, file = "mytable2.csv")


dup2 <- mytable

values <- 0
rnames <- "a"
cnames <- "b"
for(i in 1:20){
inds <- which(dup2 == max(dup2), arr.ind = TRUE)
rnames[i] <- rownames(dup2)[inds[,1]]
cnames[i] <- colnames(dup2)[inds[,2]]
values[i] <- max(dup2)
dup2[inds[,1], inds[,2]] <- 0
}

biggest_values <- cbind(rnames,cnames,values)
biggest_values <- data.frame(biggest_values, stringsAsFactors = FALSE)
biggest_values$values <- as.numeric(biggest_values$values)
biggest_values$percentage <- biggest_values$values/length(res$V1)
write.csv2(biggest_values, file = "big_values2.csv", dec=".")


