require(synapseClient)
require(survival)

## LOAD THE LOI AND NKI DATASETS
loiData <- loadEntity("syn1746086")
load(loiData@filePath)
loiExpr <- study$data
rownames(loiExpr) <- study$geneDescr[, "symb"]
loiSurv <- study$survival

nkiData <- loadEntity("syn1746087")
load(nkiData@filePath)
nkiExpr <- study$data
rownames(nkiExpr) <- study$geneDescr[, "symb"]
nkiSurv <- study$survival

## LOAD THE meta-PCNA SIGNATURE
sigData <- loadEntity("syn1746088")
load(sigData@filePath)
pcnaAll <- cbind(prolif.metagene$super_PCNA$symb, 
                 rep(0.5, length(prolif.metagene$super_PCNA$symb)))

