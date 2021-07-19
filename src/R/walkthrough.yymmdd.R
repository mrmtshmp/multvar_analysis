
for(
  fn.settings in 
  list.files("./src/R/settings", 
    pattern = "^setting_.+\\.R$")
  ){
  
  source(
  sprintf("./src/R/settings/%s",fn.settings)
  )

load(
  sprintf(
    "../data/%s", fn.ADS
    )
  )
source(
  "src/R/multvar_analysis.R"
  )


for(i in 1:length(var.Psmodel$col_name)){
  source(
    sprintf("./src/R/settings/%s", fn.settings)
    )
  
  var.Psmodel.col_name.i <-
    var.Psmodel$col_name[i]
  
  var.exposure.col_name <-
    var.exposure$col_name
  
  var.exposure$col_name <-
    var.Psmodel.col_name.i
  
  var.exposure$exposure <- NA
  
  var.Psmodel$col_name[i] <-
    var.exposure.col_name
  
  for(
    obj in 
    ls(pattern = "^fn\\.")
    ){
    assign(
      obj, 
      gsub(
        "(.+)\\.(csv|pdf)$",
        sprintf(
          "\\1\\.%s\\.\\2",
          var.Psmodel.col_name.i
          ), 
        eval(parse(text = obj))
        )
      )
    }
  source(
    "src/R/multvar_analysis.R"
    )
  print(i)
  if(!("coef.res.glm.uni_mult.rbind" %in% ls())) coef.res.glm.uni_mult.rbind <- 
    coef.res.glm.uni_mult
  
  if("coef.res.glm.uni_mult.rbind" %in% ls()) 
    coef.res.glm.uni_mult.rbind <- 
      rbind(coef.res.glm.uni_mult.rbind, coef.res.glm.uni_mult)
  }

  write.csv(
    file = sprintf("./output/%s", fn.csv.result.rbind),
    coef.res.glm.uni_mult.rbind
    )
  rm(list = ls())
  }

  
  
  