CREATE OR REPLACE FUNCTION formatUOMRatio(NUMERIC) RETURNS TEXT IMMUTABLE AS '
-- Copyright (c) 1999-2011 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  RETURN formatNumeric($1, ''uomratio'');
END;' LANGUAGE 'plpgsql';
