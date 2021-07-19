## make data settings.
# 
# dir.data <- "../../mail/210715/data/res"
# 
# fn.data <-
#   "data.xlsx"
# 
# fn.data.anorm_correct <-
#   "colinfo.suppl.xlsx"
# 
# sheet.data <- "multvar_dat"
sheet.col_info <- "colinfo.T_3"

fn.ADS  <- sprintf("multvar%s.RData", gsub("colinfo", "", sheet.col_info))
fn.pdf.res.glm.multvar <- sprintf("res.glm.multvar%s.pdf", gsub("colinfo", "", sheet.col_info))

fn.csv.result <- sprintf("res.glm.coef%s.csv", gsub("colinfo", "", sheet.col_info))
fn.csv.result.rbind <- sprintf("res.glm.coef.rbind%s.csv", gsub("colinfo", "", sheet.col_info))