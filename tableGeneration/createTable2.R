
createTable2 <- function(){
  table2 <- file.path(figDir, "table2.txt")
  
  outputTable2 <- matrix(NA, nrow=5, ncol=2)
  rownames(outputTable2) <- c("NKI", "Loi", "METABRIC: DS-based", "METABRIC: OS-based", "OsloVal")
  colnames(outputTable2) <- c("CIN feature", "Meta-PCNA index")
  
  # ================= METABRIC dataset ===========================
  
  # Create meta-PCNA metagene
  mbGene <- probeSummarization(mbExpr, map)
  mbPcna <- apply(mbGene[intersect(rownames(mbGene), pcnaAll),], 2, median)
  
  outputTable2["METABRIC: DS-based", "CIN feature"] <- survConcordance(mbDss ~ mbAll$mitotic)$concordance
  outputTable2["METABRIC: DS-based", "Meta-PCNA index"] <- survConcordance(mbDss ~ mbPcna)$concordance
  outputTable2["METABRIC: OS-based", "CIN feature"] <- survConcordance(mbSurv ~ mbAll$mitotic)$concordance
  outputTable2["METABRIC: OS-based", "Meta-PCNA index"] <- survConcordance(mbSurv ~ mbPcna)$concordance
  
  #================= OsloVal dataset ============================
  
  # Create meta-PCNA metagene
  ovGene <- probeSummarization(ovExpr, map)
  ovPcna <- apply(ovGene[intersect(rownames(ovGene), pcnaAll),], 2, median)
  
  outputTable2["OsloVal", "CIN feature"] <- survConcordance(ovSurv ~ ovAll$mitotic)$concordance
  outputTable2["OsloVal", "Meta-PCNA index"] <- survConcordance(ovSurv ~ ovPcna)$concordance
  
  #================= NKI dataset ================================
  
  # Create meta-PCNA metagene
  mapNki <- cbind(rownames(nkiExpr))
  rownames(mapNki) <- rownames(nkiExpr)
  metaNki <- CreateMetageneSpace(nkiExpr, attractome.minimalist, mapNki)$metaSpace
  nkiPcna <- apply(nkiExpr[intersect(rownames(nkiExpr), pcnaAll),], 2, median)
  
  outputTable2["NKI", "CIN feature"] <- survConcordance(nkiSurv ~ metaNki["mitotic", ])$concordance
  outputTable2["NKI", "Meta-PCNA index"] <- survConcordance(nkiSurv ~ nkiPcna)$concordance
  
  #================ Loi dataset ==============================
  
  # Create meta-PCNA metagene
  mapLoi <- cbind(rownames(loiExpr))
  rownames(mapLoi) <-  rownames(loiExpr)
  metaLoi <- CreateMetageneSpace(loiExpr, attractome.minimalist, mapLoi)$metaSpace
  loiPcna <- apply(loiExpr[intersect(rownames(loiExpr), pcnaAll),], 2, median)
  
  outputTable2["Loi", "CIN feature"] <- survConcordance(loiSurv ~ metaLoi["mitotic", ])$concordance
  outputTable2["Loi", "Meta-PCNA index"] <- survConcordance(loiSurv ~ loiPcna)$concordance
  
  
  write.table(outputTable2, file=table2, row.names=T, col.names=NA, sep="\t", quote=F)
  
  return(table2)
}
