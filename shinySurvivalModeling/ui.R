require(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Attractor Metagenes in Breast Cancer",
              "Attractor Metagenes in METABRIC and Oslo Validation Datasets"),
  
  sidebarPanel(
    
    wellPanel(
      checkboxGroupInput(inputId="mgVars", 
                         label=strong("Metagenes:"),
                         choices=c("Mitotic Chomosomal Instability (CIN)" = "mitotic",
                                   "Mesenchymal Transition (MES)" = "mt",
                                   "Lymphocyte-specific" = "ls",
                                   "Estrogen Receptor" = "er",
                                   "HER2" = "erbb2",
                                   "Adipocyte" = "adipoq",
                                   "Chr8q24.3" = "puf60",
                                   "Chr7p11.2" = "chr7p11.2",
                                   "ZMYND10 Metagene" = "zmynd10",
                                   "FGD3-SUSD3 Metagene" = "susd3",
                                   "PGR-RAI2 Metagene" = "pgr",
                                   "Chr15q26.1" = "chr15q26.1"))
    ),
    
    wellPanel(
      checkboxGroupInput(inputId="clinVars", 
                         label=strong("Clinical Variables:"),
                         choices=c("Tumor size (cm)" = "size",
                                   "Grade" = "grade",
                                   "Number of positive lymph nodes" = "lymph_nodes_positive",
                                   "Age" = "age_at_diagnosis",
                                   "ER Expression" = "ER.Expr",
                                   "PR Expression" = "PR.Expr",
                                   "HER2 Expression" = "Her2.Expr"))
    ),
    
    br()
  ),
  
  mainPanel(
    
    conditionalPanel(
      condition = "input.mgVars != '' | input.clinVars !=''",
      wellPanel(
        h4("METABRIC training data"),
        textOutput("mbConcordance")
      ),
      
      wellPanel(
        h4("Oslo validation data"),
        textOutput("ovConcordance")
      )
    ),
    
    h3("Breast Cancer Challenge Results (Oslo Validation)"),
    plotOutput("awesomePlot")
  )
))


