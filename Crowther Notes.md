### Best practices  
- Pair programmaing  
- Weekly stand up 1 minute meetings  
- Team development on shared repos  
- Keeping meticulous notes on method development, e.g. Collaboratory, Jupyter or Observablehq notebooks  
- Make code free, public and open (on GitHub)  
- Make datasets free, public and open (on GEE)  

PRODUCERS ACCURACY = What % of class did I get right? e.g. I predicted 21 out of a total of 27 points of the actual class  
CONSUMERS ACCURACY = What % of class on the map are actually that class? e.g. the map shows 27 points as water but on 21 of them are actually water - this is also called the RELIABILITY  

### ABOUT ME:  
Head of GIS at UNEP WCMC  
Water paper in Nature  
ESRI Society for Conservation GIS Award for best website  
Water Story Map - click any point and see its history  
Marxan Web and TNC  
Google Earth Engine Tools  
Google App Engine - Hosted Earth Engine  
Partnering with ESRI, Safe Software, Microsoft and Mapbox  
Associate Expert for Wetlands International  
Species Distribution Modelling  
GBIF  
Map of natural/semi-natural habitats, restoration potential and ecological intactness  
Myanmar have a big restoration programme
REDD measurement, reporting and verification (MRV)  
GEOBON Essential Biodiversity Variables  
MAPOFLIFE  
IUCN Red List of Threatened Species  
Living Planet Index  
Jim Thomas - Tenkile - SMART tool - remote sensing help - 2 Malaysian families  
Lillian Pintea - Jane Goodall  

### WATER PAPER  
- Conversion to HSV  
- All imagery was top of atmosphere, not surface reflectance!!  
- Used all Landsat 7 (not gap filled)  
- Landsat 8 Thermal Band failed in Dec 2015  
- Monthly data for 32 years for everywhere on the earth  

### THE TEAM  
Spatial scientists/GIS Analysts  
- Fragmentation and connectivity  
- Cartography  
- Geodesign  

Software engineers  
- Software development  

Data scientists  
- Use of machine learning  

Remote sensing scientists  
Economists  
Ecologists  
- SDM  

Legal advisors  
- Land tenure  

### METHODS  
Ecological forecasting  
Species ecological niche modelling  

### MEASURING IMPACT  
Return of keystone species  

### DATASETS  

### LAND COVER  
MODIS Land Cover Type - annual 500m - 5 forest classes  
ESA Climate Change Initiative - 300m UN Land Cover Classification System from 1992  

### VEGETATION INDEX  
NDVI is  NIR-Red/NIR+Red  

### PHENOLOGY  
MODIS Land Cover Dynamics - 500m  

### BURNT SEVERITY  
SWIR (Mid Infra Red) - the higher the reflectance the greater the severity  
Normalised Burn Ratio NBR  
Compare pre-fire NBR to post NBR to get an idea of burn severity  

### TREE MORTALITY  
Xylella fastidiosa on Olive trees  
Pine Wood Nematode on Pine trees  

### CLIMATE  
WorldClim 1970-2000 from gridded climate data from a network of climate stations  
GCM Global Climate Models and more recently EARTH MODELS which are more complex  
RCM Regional Climate Models  
REPRESENTATIVE CONCENTRATION PATHWAYS (RCP) - IPCCs sets of concentrations of greenhouse gases to be used in models  
Use one RCP if modelling up to 2050, but use 4.5 and 8.5 if going to the end of century  
Model performance varies between regions - there is NO SINGLE MODEL THAT OUTPERFORMS OTHERS  
More uncertainty in precipitation as it varies locally much more - and so there are big gaps in the historic record in some places - so it is HARD TO ASSESS MODELS  
CLIMATE MODEL OUTPUT IS RARELY USED IN ECOLOGICAL STUDIES - too coarse and bias can be high  
Solutions are DOWNSCALING (e.g. to be able to see refugia) and bias correction  
SENSITIVITY ANALYSIS to look at how species may be affected in the future  

### GEDI - Ecosystem LIDAR (Global Ecosystems Dynamics Investigation)  
Satellite based LIDAR to look at  


### RESTORATION  
Does the soil still exist?  
Are the viable seeds in the seedbank?  
Has the local climate changed irreversibly, e.g. no more rainfall?  
State and Transition SIMULATION MODELS  
EO Wilsons Half Earth  


### COMMENTS ON DEVINS CODE  
When you write any assets, you should include full metadata about how they were produced.  

### BIOME FUTURE PREDICTIONS  
#### PREDICTING BIOMES WITH CLIMATE DATASETS  
I like the giant CROWTHER COMPOSITE DATASET!  
Impressive to get Biomes without ANY SPECTRAL DATA!  
How were the RF parameters numberOfTrees and variablesPerSplit set?  
Why those specific topographic and soil features?  
Why use bootstrapping when Random Forest already uses it?  
Why worry about accuracy when the BIOCLIM data will vary widely?  
It takes a very long time  
Would be good to have docs embedded  

#### PREDICTING TREE COVER  
Why not just use the Hansen data?  
Where is the sample data from and is it really noisy?  
Not many samples - if you want to use MACHINE LEARNING in the future you will need lots of labelled samples  
There are samples of forests that have treecover that ranges from 0 -> 100 - why?  
How were the covariates picked?  
	Annual_Mean_Temperature, Annual_Precipitation, Elevation, 	Depth_to_bedrock,Precipitation_Seasonality,Mean_Temperature_of_Warmest_Quarter",Precipitation_of_Driest_Quarter,Sand_Content,Sand_Content_005cm,Northness,Eastness  
Low coefficiency of determination 0.57  
How were the RF parameters numberOfTrees and variablesPerSplit set?  
Why use Pandas when you can use GEE?  
GEDI will help in getting sample data.  

### TIMESERIES IN EE  
From Nick Clintons talk  
Detrending  
Stationarity  
HARMONIC MODEL - display using HSV  
AUTO-COVARIANCE and AUTO-CORRELATION - no idea  


Matt Hanchers talk about GCP - brilliant!  
GOOGLE CLOUD SQL - MANAGED POSTGIS DATABASE!!!  
CLOUD DATALAB INCLUDES ALL THE OTHER TOOLS! And you can set up with GEE by default  
CLOUD MACHINE LEARNING ENGINE (MLE) - serverless machine learning environment with tensorflow  


### PROJECTS
UK Land Cover Map 2000
Bat conservation
Recorder 2000 Data Capture Software
National Biodiversity Network
CEH and BRC development work
Ordnance Survey Mastermap importer
Ramsar Convention Reporting (automated spreadsheets)
ArcGIS Marxan Addin
Wetland Bird Survey analysis and reporting
Butterfly Monitoring Scheme analysis and website
Seabird Monitoring Scheme analysis and publication
UK Biodiversity Action Plan website
Arcus Great Apes project
GEOBON Essential Biodiversity Variables
Global Islands Database
WDPA System review
Critical Site Network Tool (award winning)
Circumpolar Biodiversity Monitoring Programme
Marxan web
Global Surface Water Dataset
Digital Observatory for Protected Areas
BIOPAMA Reference Information System - Policy | Target | Indicators
Metadata harvesting for ecosystem service publications
WDPA Version Checking tool
Species Charisma project
IUCN Red List analysis in Hadoop
Roadless forest validation tool
Xylella fastidiosa validation tool for olive trees

### NOTES ON PYTHON COURSE
- join lists with +
- row of hyphens print(80*"-")
- tuples use less memory than lists
- sys.getsizeof() to get the size of memory for a variable
- https://www.youtube.com/watch?v=NI26dqhs2Rk&list=PLi01XoE8jYohWFPpC17Z-wWhPOSuh8Er-&index=16 @3:43 using timeit
- tuples much quicker than lists
- Make a tuple without the parentheses, e.g. test = 1,2,3
- https://www.youtube.com/watch?v=Qk0zUZW-U_M&list=PLi01XoE8jYohWFPpC17Z-wWhPOSuh8Er-&index=18 @5:41 memoisation!!!!
- random.normalvariate creates random numbers from a normal Distribution

### Notes for Google call
#### Comments on Tom Elliots email to Google:
- KEY THING IS WHAT ARE YOU MONITORING AND WHY???? WHAT ARE THE SPECIFIC AIMS?
  - The purposes of monitoring:
	  - to inform conservation action
		- Natural Capital Accounting
- Other required monitoring:
  - Environmental/climatic variables
	- Biomass
	- Species composition
- NDVI is not subject to changes in illumination as it is a ratio of bands (NIR - Red)/ (NIR + Red)
- Resolution issue - can do spectral unmixing
- Canopy recognition in Pine wood nematode - tree crown delineation - iterative region growing algorithm
- Changes in tree cover around the globe at 3m resolution! I THINK NOT!
  - Why use deep learning? You could use tree crown delineation easily
  - Fantastically ambitious and unrealistic - what is the purpose?
  - What do you mean by changes in tree cover? There are many definitions of what constitutes a forest
	  - Also, are you looking to identify what species, e.g. it might be plantations
  - Quarterly review of tree gain/loss at the global scale is impossible!
	- Why globally? A single method for the whole world probably wont work
	- What do you mean by trained on annual data/quarterly data?
- Access and licensing of imagery
  - Unlikely you can redistribute or even show imagery to others
	- Simply derive new data from it
-

### Ideas
#### Wireless sensor networks
Measure temperature, humidity, wind etc across restoration sites at different heights etc.

#### Site inventory

#### Madingley model

#### GEDI - Ecosystem LIDAR (Global Ecosystems Dynamics Investigation)  

#### Canopy heights
Nico Lang from ETH:
Country-wide high-resolution vegetation height mapping with Sentinel-2
https://medium.com/ecovisioneth/mapping-forest-structures-with-deep-learning-c1d3c1b41e4e

#### Alert systems
Opportunities for improving conservation early warning and alert systems
https://zslpublications.onlinelibrary.wiley.com/doi/full/10.1002/rse2.163

### Tom call 01/06/2020
- Is it still the CTO position?
- Who will be evaluating? Who makes decisions at Restor?
- When is the meeting?
- Timescale  - is Restor up and running? Are these new people in Crowther Lab or Restor?

Tom has had a quote for €150k for 150000km2 of planet imagery
Icesat - from NASA - Michael Schaepman from ETH RS Department - launched in 2018
Forest structure, tree species diversity but mainly in Switzerland - they own a couple of planes and hyperspectral
new relationship with Crowther and Restor - Dept of Geography
Hyperspecral drone is about €6k
10k restoration projects that we think are out there
I estimated at €3-4k per project

Can we ask Google to license us the tech in StreetView (which includes LIDAR) to do ForestView:
- Can measure vegetation growth in restoration plots
- Can calibrate GEDI
- Can be used elsewhere to estimate above ground standing carbon (Natural Capital Accounting)
- Can we miniaturise it to do >10,000 restoration projects? Like StreetView Trekker

Using Street View Trekker
Getting accurate assessments of above ground biomass in tropical forests can help calibrate GEDI for larger area estimates
