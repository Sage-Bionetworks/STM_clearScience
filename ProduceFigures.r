require(synapseClient)
require(devtools)
require(Biobase)
require(survival)
require(BCC)

install_github(repo="DreamBox7", username="weiyi-bitw", ref="master")
library(DreamBox7)

data(map)
data(attractome.minimalist)

#=============================================
#	Load METABRIC and OSLO data
#============================================

synapseLogin()

metabric = loadEntity('syn1465025')$objects
#
# Since I don't have read access to the full metabric now, 
# I used the following to load a local copy
#
#load("~/workspace/data/dream7/fullrenorm/metabric2000.rdata")
clnc = lazyImputeDFClncOslo(metabric$Complete_METABRIC_Clinical_Features_Data)
clinical <- expandClncOslo(clnc)

ge = exprs(metabric$Complete_METABRIC_Expression_Data)
o = CreateMetageneSpace(ge, attractome=attractome.minimalist, map=map)
meta = o$metaSpace

# keep mesenchymal and lymph-specific metagene for conditioning
ls = meta["ls",]
mt = meta["mt",]

# median-center each metagene
meta = t(apply(meta, 1, function(x){ x - median(x)}))
surv = metabric$Complete_METABRIC_Clinical_Survival_Data_DSS

# load OSLOVAL object

intClncDat = loadEntity("syn1449480")$objects$xIntClinDat
intCnvEset = loadEntity("syn1449473")$objects$xCnvDat
intSurvObject = loadEntity("syn1449477")$objects$xIntSurvObj
intExprEset = loadEntity("syn1449475")$objects$xExprDat

oslo = list(expr = intExprEset, cnv = intCnvEset, clnc = intClncDat, surv = intSurvObject)

clnc.oslo = lazyImputeDFClncOslo(oslo$clnc)
clinical.oslo <- expandClncOslo(clnc.oslo)

ge.oslo = exprs(oslo$expr)
o = CreateMetageneSpace(ge.oslo, attractome=attractome.minimalist, map=map)
meta.oslo = o$metaSpace

# keep mesenchymal and lymph-specific metagene for conditioning
ls.oslo = meta["ls",]
mt.oslo = meta["mt",]

# median-center each metagene
meta.oslo = t(apply(meta.oslo, 1, function(x){ x - median(x)}))
surv.oslo = oslo$surv

#===============================================
#	survival curves
#===============================================

dir.create("figs")

#-------------------
#  figure 1: mitotic
#-------------------

#
#
#  fig1A: metabric mitotic
#
#

#Mitotc
metafeature=meta["mitotic",]
metafeature = metafeature - median(metafeature)
time=surv[,1]
status=surv[,2]

# truncate to 15-year survival
ii = time >= 15*365
time[ii] = 15*365
status[ii] = 0

X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
colnames(X)=c("time","status", "x")
fit.cin <- survfit(Surv(time, status) ~ x, data = data.frame(X))
pval.cin<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]

#Plot
tiff(file = "figs/fig1A.tiff", width = 3.5, height = 3.5, units = "in", res = 300, compression="lzw")
par(mar = c(2,2,2,1),       #plot margin
mgp = c(1, 0.4, 0))     #axis and label margin

plot(
fit.cin,
col = c("18","20"),     #Red, Blue
lwd = 1:1,
mark.time = FALSE,
main = "METABRIC",
xlab = "Days",
ylab = "% Survived",
yscale = 100,
cex.main = 0.5,
cex.axis = 0.5,
cex.lab = 0.5)

legend(2000, 0.4, c("High", "Low"),title="Mitotic CIN attractor expression level", lwd=1:1, col=c("18","20"),cex=0.4)
text(2000,0.6,paste("P-value < 2E-16 "),cex=0.5)
dev.off()       #Write

#
#
#  fig1B: mitotic oslo
#
#

metafeature=meta.oslo["mitotic",]
metafeature = metafeature - median(metafeature)
time=surv.oslo[,1]
status=surv.oslo[,2]

# truncate to 15-year survival
ii = time >= 15*365
time[ii] = 15*365
status[ii] = 0

X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
colnames(X)=c("time","status", "x")
fit.cin.oslo <- survfit(Surv(time, status) ~ x, data = data.frame(X))
pval.cin.oslo<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]

#Plot
tiff(file = "figs/fig1B.tiff", width = 3.5, height = 3.5, units = "in", res = 300, compression="lzw")
par(mar = c(2,2,2,1),       #plot margin
mgp = c(1, 0.4, 0))     #axis and label margin

plot(
fit.cin.oslo,
col = c("18","20"),     #Red, Blue
lwd = 1:1,
mark.time = FALSE,
main = "OSLOVAL",
xlab = "Days",
ylab = "% Survived",
yscale = 100,
cex.main = 0.5,
cex.axis = 0.5,
cex.lab = 0.5)

legend(2500, 0.9, c("High", "Low"),title="Mitotic CIN attractor expression level", lwd=1:1, col=c("18","20"),cex=0.4)
text(3000,0.3,paste("P-value =", round(pval.cin.oslo, 4)),cex=0.5)
dev.off()       #Write

#----------------------
#  figure 2: LYM in ER-
#----------------------

#
#
# fig2A: LYM | ER- metabric
#
#

##ER- Samples
#idx.erN = (meta["er",] < 0 & meta["erbb2", ] < 0)
idx.erN = clnc$ER.Expr=="-" 
metafeature=meta["ls",idx.erN]
metafeature = metafeature - median(metafeature)
time=surv[idx.erN,1]
status=surv[idx.erN,2]

ii = time >= 15*365
time[ii] = 15*365
status[ii] = 0

X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
colnames(X)=c("time","status", "x")
fit.erN <- survfit(Surv(time, status) ~ x, data = data.frame(X))
pval.erN<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]

#Plot
tiff(file = "figs/fig2A.tiff", width = 3.5, height = 3.5, units = "in", res = 300, compression="lzw")
par(
mar = c(2,2,2,1),       #plot margin
mgp = c(1, 0.4, 0)     #axis and label margin
)         #2 columns

#ER- Samples
plot(
fit.erN,
col = c("18","20"),     #Red, Blue
lwd = 1:1,
mark.time = FALSE,
main = "METABRIC ER-",
xlab = "Days",
ylab = "% Survived",
yscale = 100,
cex.main = 0.5,
cex.axis = 0.5,
cex.lab = 0.5)

legend(2000, 0.3, c("High", "Low"),title="Lymphocyte attractor expression level", lwd=1:1, col=c("18","20"),cex=0.4)
text(3000,0.4,paste("P-value = ",round(pval.erN,4)),cex=0.5)

dev.off()

#
#
#  fig2B: LYM | ER- oslo
#
#

idx.erN = clnc.oslo$ER.Expr=="-" 
metafeature=meta.oslo["ls",idx.erN]
metafeature = metafeature - median(metafeature)
time=surv.oslo[idx.erN,1]
status=surv.oslo[idx.erN,2]

ii = time >= 15*365
time[ii] = 15*365
status[ii] = 0

X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
colnames(X)=c("time","status", "x")
fit.erN.oslo <- survfit(Surv(time, status) ~ x, data = data.frame(X))
pval.erN.oslo<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]

#Plot
tiff(file = "figs/fig2B.tiff", width = 3.5, height = 3.5, units = "in", res = 300, compression="lzw")
par(
mar = c(2,2,2,1),       #plot margin
mgp = c(1, 0.4, 0)     #axis and label margin
)         #2 columns

#ER- Samples
plot(
fit.erN.oslo,
col = c("18","20"),     #Red, Blue
lwd = 1:1,
mark.time = FALSE,
main = "OSLOVAL ER-",
xlab = "Days",
ylab = "% Survived",
yscale = 100,
cex.main = 0.5,
cex.axis = 0.5,
cex.lab = 0.5)

legend(2000, 0.9, c("High", "Low"),title="Lymphocyte attractor expression level", lwd=1:1, col=c("18","20"),cex=0.4)
text(3000,0.2,paste("P-value = ",round(pval.erN.oslo,4)),cex=0.5)

dev.off()

#-------------------
# figure 3: LYM in ER+ with positive lymph nodes
#-------------------

# NOTE: OSLO does not have enough samples with ER+ / lymNum+ 
# to perform a meaningful analysis

##lymphNode >3 Samples
idx.erP = (clinical[,"lymph_nodes_positive"] > 4 & clnc$ER.Expr=="+")
metafeature=meta["ls",idx.erP]
metafeature = metafeature - median(metafeature)
time=surv[idx.erP,1]
status=surv[idx.erP,2]

ii = time >= 15*365
time[ii] = 15*365
status[ii] = 0

X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
colnames(X)=c("time","status", "x")
fit.erP <- survfit(Surv(time, status) ~ x, data = data.frame(X))
pval.erP<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]


tiff(file = "figs/fig3.tiff", width = 3.5, height = 3.5, units = "in", res = 300, compression="lzw")
par(
mar = c(2,2,2,1),       #plot margin
mgp = c(1, 0.4, 0)     #axis and label margin
)
#Positive lymph node number >3 Samples
plot(
fit.erP,
col = c("18","20"),     #Red, Blue
lwd = 1:1,
mark.time = FALSE,
main = "METABRIC ER+ | lymph node number > 4",
xlab = "Days",
ylab = "% Survived",
yscale = 100,
cex.main = 0.5,
cex.axis = 0.5,
cex.lab = 0.5)

legend(2000, 0.9, c("High", "Low"),title="Lymphocyte attractor expression level", lwd=1:1, col=c("18","20"),cex=0.4)
text(3000,0.1,paste("P-value = ",round(pval.erP,4)),cex=0.5)

dev.off()       #Write

#------------
# figure 4: SUSD3-FGD3 metagene
#------------

#
#
# fig4A: SUSD3-FGD3 metabric
#
#

#SUSD3-FGD3

metafeature=meta["susd3",]
metafeature = metafeature - median(metafeature)
time=surv[,1]
status=surv[,2]

ii = time >= 15*365
time[ii] = 15*365
status[ii] = 0

X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
colnames(X)=c("time","status", "x")
fit.susd3 <- survfit(Surv(time, status) ~ x, data = data.frame(X))
pval.susd3<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]

tiff(file = "figs/fig4A.tiff", width = 3.5, height = 3.5, units = "in", res = 300, compression="lzw")
par(
mar = c(2,2,2,1),       #plot margin
mgp = c(1, 0.4, 0)     #axis and label margin
)

plot(
fit.susd3,
col = c("18","20"),     #Red, Blue
lwd = 1:1,
mark.time = FALSE,
main = "METABRIC",
xlab = "Days",
ylab = "% Survived",
yscale = 100,
cex.main = 0.5,
cex.axis = 0.5,
cex.lab = 0.5)

legend(1500, 0.4, c("High", "Low"),title="SUSD3-FGD3 metagene expression level", lwd=1:1, col=c("18","20"),cex=0.4)
text(2000,0.6,paste("P-value < 2E-16 "),cex=0.5)

dev.off()       #Write

#
#
# fig4B: SUSD3-FGD3 OSLO
#
#

metafeature=meta.oslo["susd3",]
metafeature = metafeature - median(metafeature)
time=surv.oslo[,1]
status=surv.oslo[,2]

ii = time >= 15*365
time[ii] = 15*365
status[ii] = 0

X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
colnames(X)=c("time","status", "x")
fit.susd3.oslo <- survfit(Surv(time, status) ~ x, data = data.frame(X))
pval.susd3.oslo<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]

tiff(file = "figs/fig4B.tiff", width = 3.5, height = 3.5, units = "in", res = 300, compression="lzw")
par(
mar = c(2,2,2,1),       #plot margin
mgp = c(1, 0.4, 0)     #axis and label margin
)

plot(
fit.susd3.oslo,
col = c("18","20"),     #Red, Blue
lwd = 1:1,
mark.time = FALSE,
main = "OSLOVAL",
xlab = "Days",
ylab = "% Survived",
yscale = 100,
cex.main = 0.5,
cex.axis = 0.5,
cex.lab = 0.5)

legend(2500, 0.95, c("High", "Low"),title="SUSD3-FGD3 metagene expression level", lwd=1:1, col=c("18","20"),cex=0.4)
text(3000,0.4,paste("P-value =", round(pval.susd3.oslo, 4)),cex=0.5)

dev.off()       #Write

#============================
#	Scatter plots
#===========================

#------------
# figure 5: SUSD3, FGD3, ESR1
#------------

#
#
# SUSD3 vs FGD3
#
#

tiff(file = "figs/fig5A.tiff", width = 3.5, height = 3.5, units = "in", res = 300, compression="lzw")
par(
mar = c(2,2,2,1),       #plot margin
mgp = c(1, 0.4, 0)      #axis and label margin
)

#SUSD3 vs. FGD3
plot(
ge["ILMN_1785570",],
ge["ILMN_1772686",],
lwd = 1:1,
pch=20,         #dots
col="blue",
cex=0.5,
main = "Association between expression levels of SUSD3 and FGD3",
xlab = "SUSD3",
ylab = "FGD3",
cex.main = 0.5,
cex.axis = 0.5,
cex.lab = 0.5)

dev.off()       #Write

#
#
# fig5B: SUSD3-FGD3 vs ESR1
#
#

tiff(file = "figs/fig5B.tiff", width = 3.5, height = 3.5, units = "in", res = 300, compression="lzw")
par(
mar = c(2,2,2,1),       #plot margin
mgp = c(1, 0.4, 0)      #axis and label margin
)

#SUSD3 vs. ESR1
plot(
meta["susd3",],
ge["ILMN_1678535",],
lwd = 1:1,
pch=20,         #dots
col="blue",
cex=0.5,
main = "SUSD3-FGD3 metagene vs. ESR1 expression level",
xlab = "SUSD3-FGD3 metagene",
ylab = "ESR1",
cex.main = 0.5,
cex.axis = 0.5,
cex.lab = 0.5)
dev.off()       #Write
