import ee
ee.Initialize(ee.ServiceAccountCredentials('gee-service-account@andrewcottam-default.iam.gserviceaccount.com', '/Users/andrewcottam/Documents/GitHub/google-earth-engine-server/.private-key.json'))
scene = ee.Image('COPERNICUS/S2/20230112T104411_20230112T105242_T30PUB')
print(scene.bandNames().getInfo())
