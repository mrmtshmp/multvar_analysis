Bibtex <- TRUE
for(fn in list.files("./src/R/sub")) 
  source(sprintf("./src/R/sub/%s",fn))

source(sprintf("./src/R/settings/%s", "setting_210715.R"))

load(
  sprintf(
    "../data/%s", fn.ADS
    )
  )

quartz(
  family = 'Arial',
  type = 'pdf',
  file = sprintf("./output/%s", "cov_rel.pairwise.pdf"),
  width=70,
  height=70
  )
GGally::ggpairs(
  df.imported_data.completed[
    ,
    df.col_info[
      is.na(df.col_info$ID) &
        !is.na(df.col_info$col_name) &
        df.col_info$col_type !="skip",
      "col_name"
      ]
    ]
  )
dev.off()