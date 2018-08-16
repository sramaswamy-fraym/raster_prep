rm(list = ls())
library(raster)
library(GADMTools)
# Data Set up.......................................................

getwd()
setwd("C:\\Dropbox (Fraym)\\Fraym Team Folder\\Data Architecture\\satellite_data\\nigeria\\tobeprocessed_temp") #raw inputs
#dir.create("Grid_data")

#Grids
r<-list.files(".",pattern=".tif$")
r
for(i in r) {assign(unlist(strsplit(i, "[.]"))[1], raster(i))}

newproj <- crs("+proj=laea +ellps=WGS84 +lon_0=20 +lat_0=5 +units=m +no_defs") #new projection

projected_raster <- raster("C:\\Dropbox (Fraym)\\Fraym Team Folder\\Data Architecture\\satellite_data\\nigeria\\tobeprocessed_temp\\bank.tif") #can be any of the pulled in rasters
projected_raster <- projectRaster(projected_raster, crs = newproj, res = 1000) #resamples, reprojects, set sample resolution

#save
outpath <- "C:\\Dropbox (Fraym)\\Fraym Team Folder\\Data Architecture\\satellite_data\\nigeria\\processed\\1km_stack\\nga_1km_"
outfiles <- paste0(outpath, r)

#Fill in NAs Function
fill.na_fun <- function(x, i=13) {
  if(is.na(x)[i]) {
    return(mean(x, na.rm=TRUE))
  } else {
    return(x[i])
  }
}

#for loop to reproject, resample, set extent
for(i in 1:length(r)) {
  s <-raster(r[i])
  pr <- projectRaster(s,crs = newproj, res = 1000)
  rs <- resample(pr, projected_raster1)
  fs <- focal(rs, w = matrix(1, 5, 5), fun = fill.na_fun, pad = TRUE, na.rm = FALSE)
  fs2 <- focal(fs, w = matrix(1, 5, 5), fun = fill.na_fun, pad = TRUE, na.rm = FALSE)
  fs3 <- focal(fs2, w = matrix(1, 5, 5), fun = fill.na_fun, pad = TRUE, na.rm = FALSE)
  fs4 <- focal(fs3, w = matrix(1, 5, 5), fun = fill.na_fun, pad = TRUE, na.rm = FALSE)
  fs5 <- focal(fs4, w = matrix(1, 5, 5), fun = fill.na_fun, pad = TRUE, na.rm = FALSE)
  rc <- writeRaster(fs5, outfiles[i])
}