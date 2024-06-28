
# make mbtiles from tif
```
gdal_translate -of mbtiles -co ZOOM_LEVEL_STRATEGY=LOWER /Users/andrewcottam/Documents/QGIS/Data/overstory/encroachment_rendered_image.tif /Users/andrewcottam/Documents/QGIS/Data/overstory/test.mbtiles
```