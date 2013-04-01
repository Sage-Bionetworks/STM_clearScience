## THIS NEEDS TO BE USING DSS

createTable1 <- function(){
  table1 <- list()
  table1$inducing <- file.path(tableDir, "table1-inducing.txt")
  table1$protective <- file.path(tableDir, "table1-inducing.txt")
  
#   geneCCI <- apply(mbExpr, 1, function(x){
#     summary(coxph(mbSurv ~ x))$concordance["concordance.concordant"]
#   })
#   
#   geneCCI <- sort(geneCCI, decreasing=T)
#   inducing <- data.frame("Probe Set ID" = names(geneCCI)[1:50], "Concordance Index" = geneCCI[1:50])
#   
#   geneCCI <- sort(geneCCI)
#   protective <- data.frame("Probe Set ID" = names(geneCCI)[1:50], "Concordance Index" = geneCCI[1:50])
  
  
  
}
