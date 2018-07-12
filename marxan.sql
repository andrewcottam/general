--create the marxan schema
DROP SCHEMA IF EXISTS marxan CASCADE;
CREATE SCHEMA marxan;
-- comment the schema
COMMENT ON SCHEMA marxan IS 'Schema for the Marxan Systematic Conservation Planning software';
--create the bbox type to store the envelope of the country
DROP TYPE IF EXISTS bbox;
CREATE TYPE bbox AS (minx double precision, miny double precision, maxx double precision, maxy double precision);

--===============================================================================================================================================================================================================
-- Description:		Function to return equal area hexagonal grids for hex binning
-- Parameters:		areakm2 - the area of the grids to create in square kilometers
--					xmin, ymin, xmax, ymax - the minimum and maximum coordinates that define the bounding box for the hexagons - these coordinates must be in lat/long
-- Returns:			A set of geometries in the Cylindrical Equal Area projection 3410 - see here http://spatialreference.org/ref/epsg/3410/
-- THE FOLLOWING CODE COMES LARGELY FROM MICHAEL MINN'S MMQGIS PLUGIN - http://michaelminn.com/linux/mmqgis/

DROP FUNCTION IF EXISTS marxan.hex_grid(float, float, float, float, float);
CREATE FUNCTION marxan.hex_grid(areakm2 FLOAT, xmin FLOAT, ymin FLOAT, xmax FLOAT, ymax FLOAT) RETURNS SETOF geometry AS

$BODY$

DECLARE
	minpnt GEOMETRY;
	maxpnt GEOMETRY;
	minx FLOAT;
	miny FLOAT;
	maxx FLOAT;
	maxy FLOAT;
	sideLength FLOAT;
	xspacing FLOAT;
	yspacing FLOAT;
	xvertexlo FLOAT;
	xvertexhi FLOAT;
	rows INTEGER;
	columns INTEGER;

BEGIN

	-- Convert input coords to points in the 3410 projection
	minpnt = ST_Transform(ST_SetSRID(ST_MakePoint(xmin, ymin), 4326), 3410);
	maxpnt = ST_Transform(ST_SetSRID(ST_MakePoint(xmax, ymax), 4326), 3410);

	-- Get grid extents in 3410 projection
	minx = ST_X(minpnt);
	miny = ST_Y(minpnt);
	maxx = ST_X(maxpnt);
	maxy = ST_Y(maxpnt);
	
	-- Get the length of the hexagon side
	sideLength = sqrt((areakm2 * 1000000.0 * 2.0)/(sqrt(3.0) * 3));
	xspacing = sideLength + (sideLength * 0.5);
	yspacing = xspacing / 0.866025;
	
	--To preserve symmetry, hspacing is fixed relative to vspacing
	xvertexlo = 0.288675134594813 * yspacing;
	xvertexhi = 0.577350269189626 * yspacing;
	xspacing = xvertexlo + xvertexhi;
	
	--get the number of rows/columns
	rows = FLOOR((maxy - miny) / yspacing)::INTEGER;
	columns = FLOOR((maxx - minx) / xspacing)::INTEGER;
	
	--create the hexagons and return them
	RETURN QUERY 
		SELECT ST_SetSRID(ST_GeomFromText(format('POLYGON((%s %s, %s %s, %s %s, %s %s, %s %s, %s %s, %s %s))',x1,y2,x2,y3,x3,y3,x4,y2,x3,y1,x2,y1,x1,y2)), 3410) 
			FROM (SELECT minx + (c * xspacing) x1, minx + (c * xspacing) + (xvertexhi - xvertexlo) x2, minx + ((c + 1) * xspacing) x3, minx + ((c + 1) * xspacing) + (xvertexhi - xvertexlo) x4, miny + (((r * 2) + (0 + odd)) * (yspacing / 2)) y1, miny + (((r * 2) + (1 + odd)) * (yspacing / 2)) y2, miny + (((r * 2) + (2 + odd)) * (yspacing / 2)) y3
				FROM (SELECT c, r, (c % 2) odd	FROM generate_series(0, columns) AS c, generate_series(0, rows) AS r) AS sub) as points;

END
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;

--===============================================================================================================================================================================================================
-- Description:		Function to create equal area hexagonal grids for hex binning filtered for a particular country. These can be used in further analyses, e.g. Marxan
-- Parameters:		 areakm2 - the area of the grids to create in square kilometers
--								 iso3 - the country 3 letter code that you want to filter by
-- Returns:				Creates a new feature class in PostGIS in the marxan namespace with the default name of <iso3>_hexagons_<areakm2>, e.g. png_hexagons_50. These features use the Cylindrical Equal Area projection 3410 - see here http://spatialreference.org/ref/epsg/3410/
-- Required:		 The gaul_2015_simplified table

DROP FUNCTION IF EXISTS marxan.hexagons(FLOAT, TEXT);

--create the function to create the hexagons from the hexagon grid and the country boundary with the passed iso3 code
CREATE FUNCTION marxan.hexagons(areakm2 FLOAT, iso3 TEXT) RETURNS TEXT AS

$BODY$
  
DECLARE
    bounds bbox;
    tableName text DEFAULT 'pu_' || $2 || '_hexagons_' || $1;
  
BEGIN
  
  --create the table that will hold the grids that will be intersected with the area of interest to create the planning units for the marxan analysis
  DROP TABLE IF EXISTS marxan.grid;
  CREATE TABLE marxan.grid (id SERIAL, geometry geometry);
  
  --get the min/max values for the country
  SELECT ST_XMin(geom),ST_YMin(geom),ST_XMax(geom),ST_YMax(geom) INTO bounds FROM (SELECT ST_Envelope(wkb_geometry) geom FROM gaul_2015_simplified g WHERE g.iso3 = $2) AS sub;
  
  IF bounds IS NULL THEN
      RAISE EXCEPTION 'The iso3 code does not exist';
  END IF;
  
  --write the hexagons into the grid table
  INSERT INTO marxan.grid(geometry) SELECT marxan.hex_grid(areakm2, bounds.minx, bounds.miny, bounds.maxx, bounds.maxy); 
  
  --add a spatial index
  CREATE INDEX idx01 ON marxan.grid USING GIST (geometry);
  
  EXECUTE 'DROP TABLE IF EXISTS marxan.' || tableName || ';';
  EXECUTE 'CREATE TABLE marxan.' || tableName || ' (id INTEGER, geometry geometry);';
  
  -- intersect the grid with the country boundary and return the ids and geometries
  EXECUTE 'INSERT INTO marxan.' || tableName || '(id, geometry) SELECT m.id, m.geometry FROM marxan.grid m, gaul_2015_simplified g WHERE ST_Intersects(ST_Transform(m.geometry, 4326), g.wkb_geometry) AND g.iso3 = ''' || $2 || ''';'; 

  --drop the grid table
  DROP TABLE IF EXISTS marxan.grid;
  
  --return the name of the feature class created
  RETURN lower(tableName);
  
  END
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;

DROP TABLE IF EXISTS marxan.metadata_planning_units;
CREATE TABLE marxan.metadata_planning_units (
    feature_class_name text,
    alias text,
    description text,
    creation_date time with time zone,
    country_id integer,
    aoi_id integer,
    domain text,
    _area double precision
);

--===============================================================================================================================================================================================================
-- Description:		REST Services Function to create hexagonal grids - this calls the marxan.hexagons function
-- Parameters:		areakm2 - the area of the grids to create in square kilometers
--					iso3 - the country 3 letter code that you want to filter by
-- Returns:			Creates a new feature class in PostGIS in the marxan namespace with the default name of <iso3>_hexagons_<areakm2>, e.g. png_hexagons_50. These features use the Cylindrical Equal Area projection 3410 - see here http://spatialreference.org/ref/epsg/3410/
-- Required:		The gaul_2015_simplified table

DROP FUNCTION IF EXISTS marxan.get_hexagons(double precision, text);
CREATE OR REPLACE FUNCTION marxan.get_hexagons(IN areakm2 double precision,IN iso3 text)
  RETURNS TEXT AS

$BODY$  

SELECT marxan.hexagons(areakm2,iso3);

$BODY$
LANGUAGE sql VOLATILE COST 100;

COMMENT ON FUNCTION marxan.get_hexagons(double precision, text) IS 'Creates hexagons';