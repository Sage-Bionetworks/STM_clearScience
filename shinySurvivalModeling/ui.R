require(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Attractor Metagenes in Breast Cancer",
              "Attractor Metagenes in METABRIC and Oslo Validation Datasets"),
  
  sidebarPanel(
    h3("Build your own model"),
    
    wellPanel(
      h4("Metagenes"),
      checkboxInput("mitotic", "Mitotic Chomosomal Instability (CIN)"),
      checkboxInput("mt", "Mesenchymal Transition (MES)"),
      checkboxInput("ls", "Lymphocyte-specific"),
      checkboxInput("susd3", "FGD3-SUSD3 Metagene"),
      br(),
      checkboxInput("er", "Estrogen Receptor"),
      checkboxInput("erbb2", "HER2"),
      checkboxInput("adipoq", "Adipocyte"),
      checkboxInput("puf60", "Chr8q24.3"),
      checkboxInput("chr7p112", "Chr7p11.2"),
      checkboxInput("zmynd10", "ZMYND10 Metagene"),
      checkboxInput("pgr", "PGR-RAI2 Metagene"),
      checkboxInput("chr15q261", "Chr15q26.1"),
      
      h4("Clinical covariates"),
      checkboxInput("lymph_nodes_positive", "Number of positive lymph nodes"),
      checkboxInput("age_at_diagnosis", "Age"),
      br(),
      checkboxInput("size", "Tumor size (cm)"),
      checkboxInput("gradeIdx", "Grade"),
      checkboxInput("erClin", "ER status (expression)")
    ),
    
    br()
  ),
  
  mainPanel(
    
    h3("Breast Cancer Challenge Results (Oslo Validation)"),
    plotOutput("awesomePlot"),
    
    conditionalPanel(
      condition = "input.size || input.gradeIdx || input.lymph_nodes_positive || input.age_at_diagnosis || input.erClin || input.mitotic || input.mt || input.ls || input.er || input.erbb2 || input.adipoq || input.puf60 || input.chr7p112 || input.zmynd10 || input.susd3 || input.pgr || input.chr15q261",
      wellPanel(
        h4("METABRIC training data"),
        textOutput("mbConcordance"),
        br(),
        h4("Oslo validation data"),
        textOutput("ovConcordance")
      )
    )
    
  )
))


