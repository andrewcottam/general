--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: marxan; Type: SCHEMA; Schema: -; Owner: jrc
--

CREATE SCHEMA marxan;


ALTER SCHEMA marxan OWNER TO jrc;

--
-- Name: SCHEMA marxan; Type: COMMENT; Schema: -; Owner: jrc
--

COMMENT ON SCHEMA marxan IS 'Schema for the Marxan Systematic Conservation Planning software';


SET search_path = marxan, pg_catalog;

--
-- Name: bbox; Type: TYPE; Schema: marxan; Owner: jrc
--

CREATE TYPE bbox AS (
	countryid integer,
	countryname text,
	minx double precision,
	miny double precision,
	maxx double precision,
	maxy double precision
);


ALTER TYPE marxan.bbox OWNER TO jrc;

--
-- Name: delete_planning_unit(text); Type: FUNCTION; Schema: marxan; Owner: jrc
--

CREATE FUNCTION delete_planning_unit(pu_name text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
  
DECLARE
  
BEGIN
  
delete from marxan.metadata_planning_units where feature_class_name = $1;
execute 'drop table marxan.' || pu_name  || ';';
  
  END
$_$;


ALTER FUNCTION marxan.delete_planning_unit(pu_name text) OWNER TO jrc;

--
-- Name: FUNCTION delete_planning_unit(pu_name text); Type: COMMENT; Schema: marxan; Owner: jrc
--

COMMENT ON FUNCTION delete_planning_unit(pu_name text) IS 'Deletes a planning grid and its associated metadata entry in the metadata_planning_units table';


--
-- Name: get_hexagons(double precision, text, text); Type: FUNCTION; Schema: marxan; Owner: jrc
--

CREATE FUNCTION get_hexagons(areakm2 double precision, iso3 text, domain text) RETURNS text
    LANGUAGE sql
    AS $$  

SELECT marxan.hexagons(areakm2,iso3, domain);

$$;


ALTER FUNCTION marxan.get_hexagons(areakm2 double precision, iso3 text, domain text) OWNER TO jrc;

--
-- Name: FUNCTION get_hexagons(areakm2 double precision, iso3 text, domain text); Type: COMMENT; Schema: marxan; Owner: jrc
--

COMMENT ON FUNCTION get_hexagons(areakm2 double precision, iso3 text, domain text) IS 'Creates hexagons';


--
-- Name: getcountries(); Type: FUNCTION; Schema: marxan; Owner: jrc
--

CREATE FUNCTION getcountries() RETURNS TABLE(ogc_fid integer, id_object numeric, id_country numeric, name_iso31 character varying, sovereign_ character varying, sovereig_1 character varying, sovereig_2 character varying, iso3 character varying, iso2 character varying, un_m49 character varying, source character varying, status character varying, original_d character varying, original_n character varying, source_cod character varying, orig_ogc_f numeric, shape_leng numeric, shape_area numeric, inpoly_fid numeric, simpgnflag numeric, maxsimptol numeric, minsimptol numeric)
    LANGUAGE sql
    AS $$  
SELECT     ogc_fid ,
    id_object,
    id_country,
    name_iso31 ,
    sovereign_ ,
    sovereig_1 ,
    sovereig_2 ,
    iso3 ,
    iso2 ,
    un_m49 ,
    source ,
    status ,
    original_d ,
    original_n ,
    source_cod ,
    orig_ogc_f ,
    shape_leng ,
    shape_area ,
    inpoly_fid ,
    simpgnflag ,
    maxsimptol ,
    minsimptol 
 FROM marxan.gaul_2015_simplified_1km
$$;


ALTER FUNCTION marxan.getcountries() OWNER TO jrc;

--
-- Name: FUNCTION getcountries(); Type: COMMENT; Schema: marxan; Owner: jrc
--

COMMENT ON FUNCTION getcountries() IS 'Returns countries';


--
-- Name: getcountries2(); Type: FUNCTION; Schema: marxan; Owner: jrc
--

CREATE FUNCTION getcountries2() RETURNS TABLE(iso3 character varying, original_n character varying)
    LANGUAGE sql
    AS $$  
SELECT     
    iso3 ,
  
    original_n 
 FROM marxan.gaul_2015_simplified_1km where original_n not like '%|%' and iso3 not like '%|%' order by 2
$$;


ALTER FUNCTION marxan.getcountries2() OWNER TO jrc;

--
-- Name: FUNCTION getcountries2(); Type: COMMENT; Schema: marxan; Owner: jrc
--

COMMENT ON FUNCTION getcountries2() IS 'Returns countries';


--
-- Name: getplanningunits(); Type: FUNCTION; Schema: marxan; Owner: jrc
--

CREATE FUNCTION getplanningunits() RETURNS TABLE(feature_class_name text, alias text, description text, creation_date text, country_id integer, aoi_id integer, domain text, _area double precision)
    LANGUAGE sql
    AS $$  
SELECT feature_class_name ,
alias ,
    description ,
    creation_date::text ,
    country_id ,
    aoi_id,
    domain,
    _area 
 FROM marxan.metadata_planning_units order by 1
$$;


ALTER FUNCTION marxan.getplanningunits() OWNER TO jrc;

--
-- Name: FUNCTION getplanningunits(); Type: COMMENT; Schema: marxan; Owner: jrc
--

COMMENT ON FUNCTION getplanningunits() IS 'Gets the available planning units';


--
-- Name: hex_grid(double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: marxan; Owner: jrc
--

CREATE FUNCTION hex_grid(areakm2 double precision, xmin double precision, ymin double precision, xmax double precision, ymax double precision) RETURNS SETOF public.geometry
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION marxan.hex_grid(areakm2 double precision, xmin double precision, ymin double precision, xmax double precision, ymax double precision) OWNER TO jrc;

--
-- Name: hexagons(double precision, text, text); Type: FUNCTION; Schema: marxan; Owner: jrc
--

CREATE FUNCTION hexagons(areakm2 double precision, iso3 text, domain text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
  
DECLARE
    bounds marxan.bbox;
    tableName text DEFAULT lower('pu_' || $2 || '_' || $3 || '_hexagons_' || $1);
    aliasname text;
  
BEGIN
  
  --create the table that will hold the grids that will be intersected with the area of interest to create the planning units for the marxan analysis
  DROP TABLE IF EXISTS marxan.grid;
  CREATE TABLE marxan.grid (id SERIAL, geometry geometry);

  --get the min/max values for the country
  IF upper($3) = 'TERRESTRIAL' THEN
    SELECT ogc_fid,original_n, ST_XMin(geom),ST_YMin(geom),ST_XMax(geom),ST_YMax(geom) INTO bounds FROM (SELECT ogc_fid,original_n, ST_Envelope(wkb_geometry) geom FROM marxan.gaul_2015_simplified_1km g WHERE g.iso3 = $2) AS sub;
  ELSE
    SELECT ogc_fid,original_n, ST_XMin(geom),ST_YMin(geom),ST_XMax(geom),ST_YMax(geom) INTO bounds FROM (SELECT ogc_fid,original_n, ST_Envelope(wkb_geometry) geom FROM marxan.eez_simplified_1km g WHERE g.iso3 = $2) AS sub;
  END IF;
    
  IF bounds IS NULL THEN
      RAISE EXCEPTION 'The iso3 code does not exist';
  END IF;
  
  --get the alias name for the hexagons
  aliasname := bounds.countryName || ' ' || $3 || ' ' || $1 || 'Km2 hexagon grid';
  
  --write the hexagons into the grid table
  INSERT INTO marxan.grid(geometry) SELECT marxan.hex_grid(areakm2, bounds.minx, bounds.miny, bounds.maxx, bounds.maxy); 
  
  --add a spatial index
  CREATE INDEX idx01 ON marxan.grid USING GIST (geometry);
  
  --create the output table
  EXECUTE 'DROP TABLE IF EXISTS marxan.' || tableName || ';';
  EXECUTE 'CREATE TABLE marxan.' || tableName || ' (id INTEGER, geometry geometry);';
  
  -- intersect the grid with the country boundary and write the results to the output table
  IF upper($3) = 'TERRESTRIAL' THEN
    EXECUTE 'INSERT INTO marxan.' || tableName || '(id, geometry) SELECT m.id, m.geometry FROM marxan.grid m, marxan.gaul_2015_simplified_1km g WHERE ST_Intersects(ST_Transform(m.geometry, 4326), g.wkb_geometry) AND g.iso3 = ''' || $2 || ''';'; 
  ELSE
    EXECUTE 'INSERT INTO marxan.' || tableName || '(id, geometry) SELECT m.id, m.geometry FROM marxan.grid m, marxan.eez_simplified_1km g WHERE ST_Intersects(ST_Transform(m.geometry, 4326), g.wkb_geometry) AND g.iso3 = ''' || $2 || ''';'; 
  END IF;

  --drop the temporary grid table
  DROP TABLE IF EXISTS marxan.grid;
  
  -- insert a record in the metadata table
  EXECUTE 'INSERT INTO marxan.metadata_planning_units(feature_class_name, alias, description, creation_date, country_id, aoi_id, domain, _area) values (''' || tableName || ''',''' || aliasname || ''',''Bla bla bla'', now(), ' || bounds.countryId || ', null,''' || $3 || ''',' || $1 || ');';
  
  --return the name of the feature class created
  RETURN (tableName, aliasname);
  
  END
$_$;


ALTER FUNCTION marxan.hexagons(areakm2 double precision, iso3 text, domain text) OWNER TO jrc;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: eez_simplified_1km; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE eez_simplified_1km (
    ogc_fid integer NOT NULL,
    id_object numeric(10,0),
    id_country numeric(10,0),
    name_iso31 character varying(254),
    sovereign_ character varying(254),
    sovereig_1 character varying(254),
    sovereig_2 character varying(254),
    iso3 character varying(254),
    iso2 character varying(254),
    un_m49 character varying(254),
    source character varying(254),
    status character varying(254),
    original_d character varying(254),
    original_n character varying(254),
    source_cod character varying(254),
    orig_ogc_f numeric(10,0),
    shape_leng numeric(19,11),
    shape_area numeric(19,11),
    inpoly_fid numeric(10,0),
    simpgnflag numeric(5,0),
    maxsimptol numeric(19,11),
    minsimptol numeric(19,11),
    wkb_geometry public.geometry(Geometry,4326)
);


ALTER TABLE marxan.eez_simplified_1km OWNER TO jrc;

--
-- Name: eez_simplified_1km_ogc_fid_seq; Type: SEQUENCE; Schema: marxan; Owner: jrc
--

CREATE SEQUENCE eez_simplified_1km_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE marxan.eez_simplified_1km_ogc_fid_seq OWNER TO jrc;

--
-- Name: eez_simplified_1km_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: marxan; Owner: jrc
--

ALTER SEQUENCE eez_simplified_1km_ogc_fid_seq OWNED BY eez_simplified_1km.ogc_fid;


--
-- Name: gaul_2015_simplified_1km; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE gaul_2015_simplified_1km (
    ogc_fid integer NOT NULL,
    id_object numeric(10,0),
    id_country numeric(10,0),
    name_iso31 character varying(254),
    sovereign_ character varying(254),
    sovereig_1 character varying(254),
    sovereig_2 character varying(254),
    iso3 character varying(254),
    iso2 character varying(254),
    un_m49 character varying(254),
    source character varying(254),
    status character varying(254),
    original_d character varying(254),
    original_n character varying(254),
    source_cod character varying(254),
    orig_ogc_f numeric(10,0),
    area_km2 numeric(19,11),
    shape_leng numeric(19,11),
    shape_area numeric(19,11),
    inpoly_fid numeric(10,0),
    simpgnflag numeric(5,0),
    maxsimptol numeric(19,11),
    minsimptol numeric(19,11),
    wkb_geometry public.geometry(Geometry,4326)
);


ALTER TABLE marxan.gaul_2015_simplified_1km OWNER TO jrc;

--
-- Name: gaul_2015_simplified_1km_ogc_fid_seq; Type: SEQUENCE; Schema: marxan; Owner: jrc
--

CREATE SEQUENCE gaul_2015_simplified_1km_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE marxan.gaul_2015_simplified_1km_ogc_fid_seq OWNER TO jrc;

--
-- Name: gaul_2015_simplified_1km_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: marxan; Owner: jrc
--

ALTER SEQUENCE gaul_2015_simplified_1km_ogc_fid_seq OWNED BY gaul_2015_simplified_1km.ogc_fid;


--
-- Name: metadata_planning_units; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE metadata_planning_units (
    feature_class_name text,
    alias text,
    description text,
    creation_date time with time zone,
    country_id integer,
    aoi_id integer,
    domain text,
    _area double precision,
    envelope public.geometry
);


ALTER TABLE marxan.metadata_planning_units OWNER TO jrc;

--
-- Name: pu_asm_marine_hexagons_30; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_asm_marine_hexagons_30 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_asm_marine_hexagons_30 OWNER TO jrc;

--
-- Name: pu_asm_terrestrial_hexagons_10; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_asm_terrestrial_hexagons_10 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_asm_terrestrial_hexagons_10 OWNER TO jrc;

--
-- Name: pu_asm_terrestrial_hexagons_20; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_asm_terrestrial_hexagons_20 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_asm_terrestrial_hexagons_20 OWNER TO jrc;

--
-- Name: pu_cok_marine_hexagons_50; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_cok_marine_hexagons_50 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_cok_marine_hexagons_50 OWNER TO jrc;

--
-- Name: pu_cok_terrestrial_hexagons_10; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_cok_terrestrial_hexagons_10 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_cok_terrestrial_hexagons_10 OWNER TO jrc;

--
-- Name: pu_cok_terrestrial_hexagons_20; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_cok_terrestrial_hexagons_20 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_cok_terrestrial_hexagons_20 OWNER TO jrc;

--
-- Name: pu_cok_terrestrial_hexagons_30; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_cok_terrestrial_hexagons_30 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_cok_terrestrial_hexagons_30 OWNER TO jrc;

--
-- Name: pu_mhl_terrestrial_hexagons_10; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_mhl_terrestrial_hexagons_10 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_mhl_terrestrial_hexagons_10 OWNER TO jrc;

--
-- Name: pu_mhl_terrestrial_hexagons_40; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_mhl_terrestrial_hexagons_40 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_mhl_terrestrial_hexagons_40 OWNER TO jrc;

--
-- Name: pu_png_terrestrial_hexagons_100; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_png_terrestrial_hexagons_100 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_png_terrestrial_hexagons_100 OWNER TO jrc;

--
-- Name: pu_png_terrestrial_hexagons_101; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_png_terrestrial_hexagons_101 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_png_terrestrial_hexagons_101 OWNER TO jrc;

--
-- Name: pu_png_terrestrial_hexagons_50; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_png_terrestrial_hexagons_50 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_png_terrestrial_hexagons_50 OWNER TO jrc;

--
-- Name: pu_png_terrestrial_hexagons_60; Type: TABLE; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE TABLE pu_png_terrestrial_hexagons_60 (
    id integer,
    geometry public.geometry
);


ALTER TABLE marxan.pu_png_terrestrial_hexagons_60 OWNER TO jrc;

--
-- Name: ogc_fid; Type: DEFAULT; Schema: marxan; Owner: jrc
--

ALTER TABLE ONLY eez_simplified_1km ALTER COLUMN ogc_fid SET DEFAULT nextval('eez_simplified_1km_ogc_fid_seq'::regclass);


--
-- Name: ogc_fid; Type: DEFAULT; Schema: marxan; Owner: jrc
--

ALTER TABLE ONLY gaul_2015_simplified_1km ALTER COLUMN ogc_fid SET DEFAULT nextval('gaul_2015_simplified_1km_ogc_fid_seq'::regclass);


--
-- Name: eez_simplified_1km_pkey; Type: CONSTRAINT; Schema: marxan; Owner: jrc; Tablespace: 
--

ALTER TABLE ONLY eez_simplified_1km
    ADD CONSTRAINT eez_simplified_1km_pkey PRIMARY KEY (ogc_fid);


--
-- Name: gaul_2015_simplified_1km_pkey; Type: CONSTRAINT; Schema: marxan; Owner: jrc; Tablespace: 
--

ALTER TABLE ONLY gaul_2015_simplified_1km
    ADD CONSTRAINT gaul_2015_simplified_1km_pkey PRIMARY KEY (ogc_fid);


--
-- Name: mpu01; Type: CONSTRAINT; Schema: marxan; Owner: jrc; Tablespace: 
--

ALTER TABLE ONLY metadata_planning_units
    ADD CONSTRAINT mpu01 UNIQUE (feature_class_name);


--
-- Name: eez_simplified_1km_wkb_geometry_geom_idx; Type: INDEX; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE INDEX eez_simplified_1km_wkb_geometry_geom_idx ON eez_simplified_1km USING gist (wkb_geometry);


--
-- Name: gaul_2015_simplified_1km_wkb_geometry_geom_idx; Type: INDEX; Schema: marxan; Owner: jrc; Tablespace: 
--

CREATE INDEX gaul_2015_simplified_1km_wkb_geometry_geom_idx ON gaul_2015_simplified_1km USING gist (wkb_geometry);


--
-- PostgreSQL database dump complete
--
