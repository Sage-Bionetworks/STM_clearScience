require(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("",
              "Attractor Metagenes in METABRIC and Oslo Validation Datasets"),
  
  sidebarPanel(
    h3("Build your own model"),
    
    helpText("Add or remove individual metagenes or clinical feautures and fit your own Cox proportional hazards model. ",
             "Models are trained in the full METABRIC cohort and predictions made in Oslo Validation based on that model."),
    
    wellPanel(
      h4("Clinical covariates"),
      checkboxInput("lymph_nodes_positive", "Number of positive lymph nodes", TRUE),
      checkboxInput("age_at_diagnosis", "Age", TRUE),
      br(),
      checkboxInput("size", "Tumor size (mm)"),
      checkboxInput("gradeIdx", "Grade"),
      checkboxInput("erClin", "ER status (expression)"),
      
      br(),
      h4("Metagenes"),
      checkboxInput("susd3", "FGD3-SUSD3 Metagene", TRUE),
      checkboxInput("mitotic", "Mitotic Chomosomal Instability (CIN)", TRUE),
      checkboxInput("mt", "Mesenchymal Transition (MES)", TRUE),
      conditionalPanel(
        condition = "input.mt",
        wellPanel(
          checkboxInput("mtEarly", "early stage only", TRUE)
        )
      ),
      checkboxInput("ls", "Lymphocyte-specific", TRUE),
      conditionalPanel(
        condition = "input.ls",
        wellPanel(
          checkboxInput("lsErNeg", "ER- only", TRUE)
        )
      ),
      br(),
      checkboxInput("er", "Estrogen Receptor"),
      checkboxInput("erbb2", "HER2"),
      checkboxInput("adipoq", "Adipocyte"),
      checkboxInput("puf60", "Chr8q24.3"),
      checkboxInput("chr7p112", "Chr7p11.2"),
      checkboxInput("zmynd10", "ZMYND10 Metagene"),
      checkboxInput("pgr", "PGR-RAI2 Metagene"),
      checkboxInput("chr15q261", "Chr15q26.1")
    )
  ),
  
  mainPanel(
    
    h3("Challenge Results (Oslo Validation)"),
    plotOutput("awesomePlot"),
    
    br(),
    
    wellPanel(
      helpText("NOTE: Team Attractor Metagenes winning model uses an ensemble method for estimating coefficients which averages across a number of different methods. ",
               "Models fit here are Cox proportional hazards models, which was simply one of the many methods used in the ensemble model applied by Team Attractor Metagenes.")
    ),
    
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


