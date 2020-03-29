setwd("C:/Users/ivan.pisani/Desktop/Nova pasta")
library(data.table)
library(plyr)
library(RJSONIO)
library(httr)

# Variaveis que serao setadas
date_range <- 30
grouping <- "reg_cat"

# Coeficiente de multiplicacao p/ as variaveis normalizadas
alpha <- structure(rep(1/9, times=9), names=c("pc15", "days", "visits", "num_orders", "discount", "supplier_delivery_time", "conv_rate", "shipment_rate", "random"))


visits.json <- fromJSON(rawToChar(GET(paste("http://209.188.1.50/pivots/gerar_json.php?nick=RShiny_SortingAlgorithm_Visits&params=", date_range, sep=""))$content))

l <- list(
  sku_config = lapply(visits.json, '[[', 'sku_config'),
  visits = lapply(visits.json, '[[', 'visits')
)

dt.visits = data.table(do.call("cbind", lapply(l, function(x) sapply(x, function(xx) ifelse(is.null(xx), NA, xx)))))
rm(visits.json)

dt.visits$visits <- as.integer(dt.visits$visits)


catalog_total.json <- fromJSON(rawToChar(GET("http://209.188.1.50/pivots/gerar_json.php?nick=RShiny_SortingAlgorithm_Catalog")$content))

l <- list(
  sku_config = lapply(catalog_total.json, '[[', 'sku_config'),
  sku_simple = lapply(catalog_total.json, '[[', 'sku_simple'),
  reg_cat = lapply(catalog_total.json, '[[', 'reg_cat'),
  product_department = lapply(catalog_total.json, '[[', 'product_department'),
  group_category_otb = lapply(catalog_total.json, '[[', 'group_category_otb'),
  category_otb = lapply(catalog_total.json, '[[', 'category_otb'),
  config_shipment_type = lapply(catalog_total.json, '[[', 'config_shipment_type'),
  supplier_delivery_time = lapply(catalog_total.json, '[[', 'supplier_delivery_time'),
  days = lapply(catalog_total.json, '[[', 'days'),
  discount = lapply(catalog_total.json, '[[', 'discount')
)

dt.catalog_total = data.table(do.call("cbind", lapply(l, function(x) sapply(x, function(xx) ifelse(is.null(xx), NA, xx)))))
dt.catalog_total$supplier_delivery_time <- as.integer(dt.catalog_total$supplier_delivery_time)
dt.catalog_total$days <- as.integer(dt.catalog_total$days)
dt.catalog_total$discount <- as.numeric(as.character(dt.catalog_total$discount))
rm(catalog_total.json)


sales_order.json <- fromJSON(rawToChar(GET(paste("http://209.188.1.50/pivots/gerar_json.php?nick=RShiny_SortingAlgorithm_Orders&params=", date_range, sep=""))$content))

l <- list(
  sku_config = lapply(sales_order.json, '[[', 'sku_config'),
  pc15 = lapply(sales_order.json, '[[', 'pc15'),
  num_orders = lapply(sales_order.json, '[[', 'num_orders'),
  shipment_rate = lapply(sales_order.json, '[[', 'shipment_rate')
)

dt.sales_order = data.table(do.call("cbind", lapply(l, function(x) sapply(x, function(xx) ifelse(is.null(xx), NA, xx)))))
rm(sales_order.json)

dt.sales_order$pc15 <- as.numeric(as.character(dt.sales_order$pc15))
dt.sales_order$num_orders <- as.integer(dt.sales_order$num_orders)
dt.sales_order$shipment_rate <- as.numeric(as.character(dt.sales_order$shipment_rate))

dt.sku_simple_config <- dt.catalog_total[,c("sku_config","sku_simple"),with=FALSE]
dt.catalog_total$sku_simple<-NULL

dt.catalog_total <- dt.catalog_total[,list(reg_cat=reg_cat[1], config_shipment_type=config_shipment_type[1], supplier_delivery_time=min(supplier_delivery_time, na.rm=TRUE), days=days[1], discount=sum(discount, na.rm=TRUE)),by=sku_config]

# Cruzamento das tabelas de catalogo, visita e ordens
setkey(dt.visits, sku_config)
setkey(dt.catalog_total, sku_config)
setkey(dt.sales_order, sku_config)

algorithm_base <- merge(x=dt.catalog_total, y=dt.visits, all.x=TRUE)
setkey(algorithm_base, sku_config)

algorithm_base <- merge(x=algorithm_base, y=dt.sales_order, all.x=TRUE)


# Tratamento dos dados e calculo de conversion_rate
algorithm_base$days[which(algorithm_base$days > date_range)] <- NA
algorithm_base$conv_rate <- round(algorithm_base$num_orders / algorithm_base$visits, digits=3)

algorithm_base[is.na(algorithm_base)] <- 0

# Calculo dos valores maximos de cada coluna
algorithm_base[, max_pc15 := as.numeric(max(pc15, na.rm=true)), by=reg_cat]
algorithm_base[, max_days := as.numeric(max(days, na.rm=true)), by=reg_cat]
algorithm_base[, max_visits := max(visits, na.rm=true), by=reg_cat]
algorithm_base[, max_num_orders := as.numeric(max(num_orders, na.rm=true)), by=reg_cat]
algorithm_base[, max_discount := max(discount, na.rm=true), by=reg_cat]
algorithm_base[, max_supplier_delivery_time := max(supplier_delivery_time, na.rm=true), by=reg_cat]
algorithm_base[, max_conv_rate := max(conv_rate, na.rm=true), by=reg_cat]
algorithm_base[, max_shipment_rate := max(shipment_rate, na.rm=true), by=reg_cat]

algorithm_base[is.na(algorithm_base)] <- 0

# Normaliacao da base
normalized_algorithm_base <- algorithm_base[,c("reg_cat", "sku_config"), with=FALSE]
normalized_algorithm_base$pc15 <- round(algorithm_base$pc15 / algorithm_base$max_pc15, digits=3)
normalized_algorithm_base$days <- round(algorithm_base$days / algorithm_base$max_days, digits=3)
normalized_algorithm_base$visits <- round(algorithm_base$visits / algorithm_base$max_visits, digits=3)
normalized_algorithm_base$num_orders <- round(algorithm_base$num_orders / algorithm_base$max_num_orders, digits=3)
normalized_algorithm_base$discount <- round(algorithm_base$discount / algorithm_base$max_discount, digits=3)
normalized_algorithm_base$supplier_delivery_time <- round(1 - algorithm_base$supplier_delivery_time / algorithm_base$max_supplier_delivery_time, digits=3)
normalized_algorithm_base[which(algorithm_base$config_shipment_type=="Próprio")]$supplier_delivery_time <- 1
normalized_algorithm_base$conv_rate <- round(algorithm_base$conv_rate / algorithm_base$max_conv_rate, digits=3)
normalized_algorithm_base$shipment_rate <- round(algorithm_base$shipment_rate / algorithm_base$max_shipment_rate, digits=3)
normalized_algorithm_base$random <- runif(nrow(normalized_algorithm_base), 0, 1)

# Limpeza dos valores NA e Inf
normalized_algorithm_base[is.na(normalized_algorithm_base)] <- 0
normalized_algorithm_base$pc15[is.infinite(normalized_algorithm_base$pc15)] <- 0

normalized_algorithm_base[, final_val:=sum(alpha["pc15"]*pc15, alpha["days"]*days, alpha["visits"]*visits, alpha["num_orders"]*num_orders, alpha["discount"]*discount, alpha["supplier_delivery_time"]*supplier_delivery_time, alpha["conv_rate"]*conv_rate, alpha["shipment_rate"]*shipment_rate, alpha["random"]*random), by=1:nrow(normalized_algorithm_base)]

setkey(normalized_algorithm_base, sku_config)
setkey(dt.sku_simple_config, sku_config)

normalized_algorithm_base <- merge(x=normalized_algorithm_base, y=dt.sku_simple_config, all.x=TRUE)

output <- normalized_algorithm_base[,c("reg_cat", "sku_simple", "final_val"), with=FALSE]
output <- output[order(reg_cat, -final_val)]

write.table(output, file="sorting_algorithm_output.csv", row.names=FALSE, col.names=TRUE, sep=";", dec=".")

