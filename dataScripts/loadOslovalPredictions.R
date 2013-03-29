require(synapseClient)
require(survival)

oslovalResId <- "syn1725898"
oslovalResEnt <- loadEntity(oslovalResId)
ovPredictions <- oslovalResEnt$objects$osloPredictions

