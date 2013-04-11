
createTable1 <- function(){
  table1 <- list()
  table1$inducing <- file.path(figDir, "table1-inducing.txt")
  table1$protective <- file.path(figDir, "table1-protective.txt")
  
  geneCCI <- apply(mbExpr, 1, function(x){
    survConcordance(mbDss ~ x)$concordance["concordant"]
  })
  
  geneCCI <- sort(geneCCI, decreasing=T)
  inducing <- data.frame("Probe Set ID" = names(geneCCI)[1:100], 
                         "Gene Symbol" = map[names(geneCCI)[1:100], "Gene.Symbol"], 
                         "Concordance Index" = geneCCI[1:100], check.names=F)
  inducing <- inducing[!duplicated(inducing$"Gene Symbol"), ]
  inducing <- inducing[1:50, ]
  
  geneCCI <- sort(geneCCI)
  protective <- data.frame("Probe Set ID" = names(geneCCI)[1:100], 
                           "Gene Symbol" = map[names(geneCCI)[1:100], "Gene.Symbol"], 
                           "Concordance Index" = geneCCI[1:100], check.names=F)
  protective <- protective[!duplicated(protective$"Gene Symbol"), ]
  protective <- protective[1:50, ]
  
  write.table(inducing, file=table1$inducing, row.names=F, col.names=T, sep="\t", quote=F)
  write.table(protective, file=table1$protective, row.names=F, col.names=T, sep="\t", quote=F)
  
  return(table1)
}
