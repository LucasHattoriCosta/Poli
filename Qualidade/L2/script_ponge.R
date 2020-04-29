# Script da Lista 2
#
# Walter Ponge-Ferreira
# 11.03.2018
#

# Instala bibliotecas
# install.packages("UsingR")
# install.packages("moments")

# L� e prepara dados

setwd("~/Data/Pasta T�cnica/R/PME3463 Aula 02")
rm(list=ls())

# Carrega bibliotecas adicionais
library(UsingR) # para uso da fun��o DOTplot
library(moments) # para uso das fun��es skewness e kurtosis

dados <- read.csv2("Amostra 01.csv")

class(dados)
names(dados)
head(dados)
tail(dados)
str(dados)
mode(dados)

summary(dados)

fix(dados)
edit(dados)

X <- data.frame(dados[,2:5])

class(X)
str(X)
dim(X)
length(X)

x <- apply(X, 1, mean)
x

Y <- data.frame(dados[,9:12])

class(Y)
mode(Y)
dim(Y)

y <- apply(Y, 1, mean)
y

plot(x,y, type="p", col= "black", main="Lote Piloto", ylab="massa - m / g", xlab="di�metro - d / mm")
plot(X,Y)

# Estat�stica Descritiva

summary(X)
summary(Y)

# Analise do di�metro

mean(x)
mean(x, trim = 0.1)
median(x)

table(x)
which(table(x) == max(table(x)))

var(x)
sd(x)
sd(x)/mean(x)
skewness(x)
kurtosis(x)

range(x)
diff(range(x))

quantile(x, c(0.0, 0.25, 0.5, 0.75, 1.0))
IQR(x)
fivenum(x)

stem(x)

stripchart(x)
DOTplot(x)

boxplot(x)
f = fivenum(x)
text(rep(1.4,5),f,labels=c("m�nimo","dobradi�a inferior","mediana","dobradi�a superior","m�ximo"))

boxplot(x)
text(rep(1.3,5),f,labels=c("> Q1 - 1.5 IQR","Q1","med","Q3","< Q3 + 1.5 IQR"))

hist(x)
hist(x, breaks=3)
hist(x, breaks = seq(20,26,length=13))
hist(x, breaks = "scott")
hist(x, breaks = "scott", prob=TRUE, main="Amostra Piloto")
lines(density(x))
abline(v=22, col = 'red')

# An�lise da massa

mean(y)
mean(y, trim = 0.10)
median(y)

table(y)
which(table(y) == max(table(y)))

var(y)
sd(y)
sd(y)/mean(y)
skewness(y)
kurtosis(y)

range(y)
diff(range(y))

quantile(y, c(0.0, 0.25, 0.5, 0.75, 1.0))
IQR(y)
fivenum(y)

stem(y)

stripchart(y)
DOTplot(y)

boxplot(y)

hist(y)
hist(y, breaks=3)
hist(y, breaks = seq(1,2,length=11))
hist(y, breaks = "scott")
hist(y, breaks = "scott", prob=TRUE, main="Amostra Piloto")
lines(density(y))
abline(v=1.5, col = 'red')


# repete com resultados emparelhados
dim(X)

apply(X,2,quantile,c(0.00, 0.25, 0.50, 0.75, 1.00))
apply(X,2,IQR)
apply(X,2,median)

apply(X,2,mean)
apply(X,2,var)
apply(X,2,sd)
apply(X,2,sd)/apply(X,2,mean)

apply(X,1,quantile,c(0.00, 0.25, 0.50, 0.75, 1.00))
apply(X,1,IQR)
apply(X,1,median)

apply(X,1,mean)
apply(X,1,var)
apply(X,1,sd)
apply(X,1,sd)/apply(X,1,mean)

# Histograma
n <- length(y) # tamanho da amostra
k <- log(n, base = 2) # n�mero de faixas para histograma
Rx <- diff(range(x)) # amplitude amostral de x
Ry <- diff(range(y)) # amplitude amostral de y
Rx/k # largura de faixa recomendada para vari�vel x
Ry/k # largura de faixa recomendada para vari�vel y

# Adotou-se a largura de faixa de 1.0 e 0.05 para vari�veis x e y, respectivamente
x.bin=seq(from=20,to=26,by=1.0)
X.cut <- cut(x, x.bin, right = FALSE)
y.bin <- seq(from=1.2, to=1.6, by=0.05)
Y.cut <- cut(y, y.bin, right = FALSE)

x.freq <- table(X.cut)
y.freq <- table(Y.cut)

# Tabela de Frequencias
cbind(x.freq)
cbind(y.freq)
matrix(data = c(x.freq,y.freq), ncol = 2)

# Plota o histograma
hist(x,breaks=x.bin, main="Amostra Piloto", xlab = "di�metro - d / mm") # histograma de frequ�ncias
abline(v=mean(x)-c(-1,0,1)*sd(x), col="red")
abline(v=quantile(x,c(0.25,0.50, 0.75)), col="green")

hist(x,breaks=x.bin,prob=TRUE, main="Amostra Piloto", xlab="massa - m / g") # histograma de propor��es
lines(density(x))

hist(y,breaks=y.bin, main="Amostra Piloto") # histograma de frequ�ncias
abline(v=mean(y)-c(-1,0,1)*sd(y), col="red")
abline(v=quantile(y,c(0.25,0.50, 0.75)), col="green")

hist(y,breaks=y.bin,prob=TRUE, main="Amostra Piloto") # histogrma de propor��es
lines(density(y))

# Intervalo de Confian�a da m�dia - Vari�ncia Conhecida
sigma.x <- 0.8 # valor adotado
z.val <- qnorm(0.975, mean = 0, sd = 1) # z cr�tico -> coeficiente de abrang�ncia
eo.x <- z.val*sigma.x/sqrt(n) # semi-amplitude do intervalo de x -> incerteza expandida
mean(x)-eo.x
mean(x)+eo.x

sigma.y <- 0.05 # valor adotado
eo.y <- z.val*sigma.y/sqrt(n) # semi-amplitude do intervalo de y -> incerteza expandida
mean(y)-eo.y
mean(y)+eo.y

# Intervalo de Confian�a da m�dia - Vari�ncia Desconhecida
alpha <- 0.05 # n�vel de signific�ncia
t.val <- qt(1-alpha/2, df = n-1) # t cr�tico -> coeficiente de abrang�ncia
Sx <- sd(x) # desvio padr�o amostral
Sxm <- Sx / sqrt(n) # "erro padr�o" = desvio padr�o da m�dia amostral -> incerteza padr�o
eo.x <- t.val*Sxm # semi-amplitude do intervalo de confian�a de x
mean(x)-eo.x
mean(x)+eo.x
mean(x)

hist(x, breaks=x.bin, main="Amostra Piloto")
abline(v=mean(x)+c(-1,0,1)*eo.x, col="cyan")

DOTplot(x, main="Amostra Piloto")
abline(v=mean(x)+c(-1,0,1)*eo.x, col="red")

# Teste de hip�tese e intervalo de confian�a de x
# H0: mu = mo <- hip�tese nula
# H1: mu <> mo (bi-caldal) <- hip�tese alternativa
t.test(x, mu = 20.0, alternative = "two.sided", conf.level = 1-alpha )

# Teste de hip�tese e intervalo de confian�a de x
# H0: mu = mo <- hip�tese nula
# H1: mu > mo (mono-caldal) <- hip�tese alternativa
t.test(x, mu = 20.0, alternative = "greater", conf.level = 1-alpha )

# repete para vari�vel y
Sy <- sd(y)
Sym <- Sy / sqrt(n)
eo.y <- t.val*Sym
mean(y)-eo.y
mean(y)+eo.y
mean(y)

hist(y,breaks=y.bin, main="Amostra Piloto")
abline(v=mean(y)-c(-1,0,1)*eo.y, col=c("red","green","red"))

DOTplot(y, main="Amostra Piloto")
abline(v=mean(y)+c(-1,0,1)*eo.y, col=c("red","green","red"))

t.test(y, mu = 1.5, alternative = "two.sided", conf.level = 1-alpha)

# Intervalo de confian�a da Vari�ncia
#
# P(lstar <= (n-1) s2 / sigma2 <= rstar) = 1 - alpha
#
# onde (n-1)*s2/sigma2 ~ chi2(n-1)
#
lstar = qchisq(alpha/2, df = n-1)
rstar = qchisq(1-alpha/2, df = n-1)

# para vari�vel X
var(x)
(n-1)*var(x)*c(1/rstar, 1/lstar) # intervalo de confian�a da vari�ncia de x
sd(x)
sqrt((n-1)*var(x)*c(1/rstar, 1/lstar)) # intervalo de confian�a do desvio padr�o

# para vari�vel y
var(y)
(n-1)*var(y)*c(1/rstar, 1/lstar) # intervalo de confian�a da vari�nica de y
sd(y)
sqrt((n-1)*var(y)*c(1/rstar, 1/lstar)) # intervalo de confian�a do desvio padr�o

# Regress�o Linear
plot(x,y, main="Amostra Piloto", xlab="di�metro - d / mm", ylab="massa - m / g")

cor(x,y)
cov(x,y)

modelo <- lm(y ~ x)
modelo

summary(modelo)
anova(modelo)


cor.test(x,y, conf.level=0.95)

plot(y ~ x, main="Amostra Piloto", sub="Aneis Met�licos", xlab="di�metro - d / mm", ylab="massa - m / g")
abline(h=mean(y), lty = 2, col = "red")
abline(v=mean(x), lty = 2, col = "red")
abline(modelo)

betas = coef(modelo)
betas

#predict(modelo, c(20))

residuals(modelo)

plot(modelo)

# An�lise de Vari�ncia (ANOVA)
#
# Verifica se as quatro medidas dos di�metros s�o iguais
#
# Vari�vel de Teste:
#
# F = (SSTr/(k-1)) / (SSE(n-k) )
#

k <- length(X[1,]) # No. de amostras
n <- length(X[,1]) # Tamanho das amostras

summary(X)

boxplot(X)

DOTplot(X)

xbar <- mean(apply(X,2,mean))
apply(X,2,mean)
xbar

SST <- n*sum((apply(X,2,mean)-xbar)^2)
SST

SSE = (n-1)*sum(apply(X,2,var))
SSE

F.obs = (SST/(k-1) / (SSE/(n*k-k)))
pf(F.obs,k-1,n*k-k,lower.tail=FALSE)


q = stack(X)
names(q)

oneway.test(values ~ ind, data=q, var.equal = TRUE)

# Plot medidas em cores diferentes
plot(q[q$ind=="D1",1],rep(1,n), col = "red", ylim=c(0,5), main="Amostra Piloto", ylab="Medida", xlab="di�metro - d / mm")
points(q[q$ind=="D2",1], rep(2,n),col = "blue")
points(q[q$ind=="D3",1], rep(3,n),col = "green")
points(q[q$ind=="D4",1], rep(4,n),col = "black")
abline(v=xbar, lty= 2, col = "red")

# FIM