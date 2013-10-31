CREATE OR REPLACE FUNCTION public.supportedpgversion(NUMERIC, NUMERIC) 
-- Copyright (c) 1999-2013 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
RETURNS BOOLEAN AS $BODY$
DECLARE
  _minVersion ALIAS FOR $1;
  _maxVersion ALIAS FOR $2;
  _serverText TEXT := split_part(version(), ' ', 2);
  _serverVersion NUMERIC := substring(_serverText FROM $$(\d+\.\d+)\.\d+$$)::NUMERIC;
  _returnCode BOOLEAN = false;
BEGIN

RAISE NOTICE 'Server Version --> % Min --> % Max --> %', _serverVersion, _minVersion, _maxVersion;

-- check versions
IF (_serverVersion BETWEEN _minVersion AND _maxVersion) 
  THEN _returnCode := TRUE;
END IF;

RETURN _returnCode;

END;
$BODY$ LANGUAGE PLPGSQL STABLE;