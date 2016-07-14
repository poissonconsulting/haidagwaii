library(bcmaps)
library(sp)
library(rgeos)
library(magrittr)
library(devtools)

rm(list = ls())

intersect_bbox <- function(sp, xmin = NULL, xmax = NULL, ymin = NULL, ymax = NULL) {
  bbox <- bbox(sp)

  if (!is.null(xmin))
    bbox["x","min"] <- xmin
  if (!is.null(xmax))
    bbox["x","max"] <- xmax
  if (!is.null(ymin))
    bbox["y","min"] <- ymin
  if (!is.null(ymax))
    bbox["y","max"] <- ymax

  bbox <- matrix(c(bbox["x",c("min", "min", "max", "max", "min")],
                   bbox["y",c("min", "max", "max", "min", "min")]), ncol = 2)

  bbox %<>% sp::Polygon() %>% list() %>% sp::Polygons(ID = "id") %>% list() %>%
    sp::SpatialPolygons(proj4string=sp::CRS(sp::proj4string(sp)))
  sp %<>% rgeos::gIntersection(bbox, byid = TRUE)
}


haida_gwaii <- intersect_bbox(regional_districts_disp, xmax = 670000, ymax = 1100000)
haida_gwaii %<>% spTransform(CRS("+proj=longlat +ellps=WGS84"))

plot(haida_gwaii)

use_data(haida_gwaii, overwrite = TRUE)
