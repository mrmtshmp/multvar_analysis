Bibtex <- TRUE
options(scipen = FALSE)

for(fn in list.files("./src/R/sub")) 
  source(sprintf("./src/R/sub/%s",fn))

# source(
#   sprintf("./src/R/settings/%s", "setting_210715.R")
#   )

# load(
#   sprintf(
#     "../data/%s", fn.ADS
#     )
#   )

form.model.multvar <- 
  sprintf(
    "%s~%s", 
    var.event[,"col_name"], 
    paste(
      c( 
        var.exposure[,"col_name"], 
        var.Psmodel[,"col_name"]
        ),
      collapse = "+"
      )
    )

form.model.univar <- 
  sprintf(
    "%s~%s", 
    var.event[,"col_name"], 
    var.exposure[,"col_name"]
    )

res.glm.multvar <-
  glm(
    formula = as.formula(form.model.multvar),
    data = df.imported_data.completed,
    family = binomial()
    )

res.glm.univar <-
  glm(
    formula = as.formula(form.model.univar),
    data = df.imported_data.completed,
    family = binomial()
    )

quartz(
  type = "pdf", 
  file = 
    sprintf(
      "./output/%s", 
      fn.pdf.res.glm.multvar
      )
  )
plot(res.glm.multvar, main = "Multivariable Analysis")
plot(res.glm.univar, main = "Univariable Analysis")
dev.off()

coef.res.glm.multvar <-
  data.frame(
    summary(res.glm.multvar)$coef
    ) %>%
  tibble::rownames_to_column("terms") %>%
  left_join(
    data.frame(
      confint(
        res.glm.multvar
        )
      ) %>%
      tibble::rownames_to_column("terms")
    ) #%>%
  # tibble::column_to_rownames("terms")


coef.res.glm.univar <-
  data.frame(
    summary(res.glm.univar)$coef
    ) %>%
  tibble::rownames_to_column("terms") %>%
  left_join(
    data.frame(
      confint(
        res.glm.univar
        )
      ) %>%
      tibble::rownames_to_column("terms")
     ) #%>%
  # tibble::column_to_rownames("terms")


coef.res.glm.multvar[,"terms"] <- 
  c("Intercept", var.exposure$col_name, var.Psmodel$col_name)


coef.res.glm.univar["terms"] <- 
  c("Intercept", var.exposure$col_name)

coef.res.glm.univar[
  ,
  "Pr...z.."] <- 
  scales::pvalue(
    coef.res.glm.univar[
      ,
      "Pr...z.."
      ],
    accuracy = 0.001
    )

coef.res.glm.multvar[
  ,
  "Pr...z.."] <- 
  scales::pvalue(
    coef.res.glm.multvar[
      ,
      "Pr...z.."
      ],
    accuracy = 0.001
    )



coef.res.glm.univar[
  ,
  c("Estimate","X2.5..", "X97.5..")] <- 
  exp(
    coef.res.glm.univar[
      ,
      c("Estimate","X2.5..", "X97.5..")
      ]
    )

coef.res.glm.multvar[
  ,
  c("Estimate","X2.5..", "X97.5..")] <-
  exp(
    coef.res.glm.multvar[
      ,
      c("Estimate","X2.5..", "X97.5..")
      ]
    )

colnames(coef.res.glm.multvar) <- 
  gsub(
    "(Estimate|X2\\.5\\.\\.$|X97\\.5\\.\\.$|Pr\\.\\.\\.z\\.\\.$)", 
    "\\1_multvar", 
    colnames(coef.res.glm.multvar)
    )

# Output ------------------------------------------------------------------

coef.res.glm.uni_mult <-
  coef.res.glm.univar[,
        grep(
          "(terms|Estimate$|X2\\.5\\.\\.$|X97\\.5\\.\\.$|Pr\\.\\.\\.z\\.\\.$)",
          colnames(coef.res.glm.univar)
          )
        ] %>%
    left_join(
      coef.res.glm.multvar[,
        grep(
          "(terms|.+_multvar$)",
          colnames(coef.res.glm.multvar)
          )
        ]
      ,by = "terms"
      ) %>%
    bind_cols(model=form.model.multvar)

write.csv(
  file = sprintf("./output/%s", fn.csv.result),
  coef.res.glm.uni_mult
  )
