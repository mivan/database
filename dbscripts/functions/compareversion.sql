
CREATE OR REPLACE FUNCTION compareversion(text, text DEFAULT split_part(version(), ' ', 2)) 
-- Returns 1 if the left version is greater than the right version
-- -1 if the right is greater than the left
--  0 if the versions are equal.
-- parameter two defaults to current server version
RETURNS INTEGER AS $BODY$
DECLARE
  _leftVersion ALIAS FOR $1;
  _rightVersion ALIAS FOR $2;
  _leftMajor SMALLINT;
  _leftMinor SMALLINT;
  _leftPatch SMALLINT;
  _rightMajor SMALLINT;
  _rightMinor SMALLINT;
  _rightPatch SMALLINT;
  _returnCode SMALLINT;
BEGIN

-- left
SELECT  substring(_leftVersion FROM $$(\d+)\.\d+\.\d+$$)::SMALLINT, 
	substring(_leftVersion FROM $$\d+\.(\d+)\.\d+$$)::SMALLINT, 
	substring(_leftVersion FROM $$\d+\.\d+\.(\d+)$$)::SMALLINT 
	INTO _leftMajor, _leftMinor, _leftPatch;

RAISE NOTICE 'Left Version --> % Major --> % Minor --> % Patch --> % ', _leftVersion, _leftMajor, _leftMinor, _leftPatch;

-- right
SELECT  substring(_rightVersion FROM $$(\d+)\.\d+\.\d+$$)::SMALLINT, 
	substring(_rightVersion FROM $$\d+\.(\d+)\.\d+$$)::SMALLINT, 
	substring(_rightVersion FROM $$\d+\.\d+\.(\d+)$$)::SMALLINT 
	INTO _rightMajor, _rightMinor, _rightPatch;

RAISE NOTICE 'Right Version --> % Major --> % Minor --> % Patch --> % ', _rightVersion, _rightMajor, _rightMinor, _rightPatch;

-- check major version
IF (_leftMajor > _rightMajor) THEN _returnCode := 1;
ELSIF (_leftMajor < _rightMajor) THEN _returnCode := -1;
ELSIF (_leftMajor = _rightMajor) THEN
  -- if major is equal, check minor version
  IF (_leftMinor > _rightMinor) THEN _returnCode := 1;
  ELSIF (_leftMinor < _rightMinor) THEN _returnCode := -1;
  ELSIF (_leftMinor = _rightMinor) THEN
    -- if major and minor are equal, check patch version
    IF (_leftPatch > _rightPatch) THEN _returnCode := 1;
    ELSIF (_leftPatch < _rightPatch) THEN _returnCode := -1;
    ELSIF (_leftPatch = _rightPatch) THEN _returnCode := 0;
    END IF;
  END IF;
-- if we somehow don't match those three operators it probably means someone passed in a version that wasn't in numerical major.minor.patch format
ELSE RAISE EXCEPTION 'One or more of the version parameters is invalid. Expected numerical Major.Minor.Patch version string. Left --> % Right --> %', _leftVersion, _rightVersion;
END IF;

RETURN _returnCode;

END;
$BODY$ LANGUAGE PLPGSQL STABLE;