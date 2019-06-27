CREATE OR REPLACE FUNCTION marxan.hexagons(areakm2 FLOAT, iso3 TEXT)
  RETURNS SETOF geometry AS
$BODY$

DECLARE
  bounds record;
  
BEGIN

  -- Return the hexagons - done in pairs, with one offset from the other
  RETURN QUERY (SELECT ST_Point(10,0));

END$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;