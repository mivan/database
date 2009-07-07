CREATE OR REPLACE FUNCTION moveUiform(INTEGER, INTEGER, INTEGER) RETURNS INTEGER AS $$
DECLARE
  puiformid ALIAS FOR $1;
  poldpkgid ALIAS FOR $2;
  pnewpkgid ALIAS FOR $3;

  _deletestr    TEXT;
  _destination  TEXT;
  _insertstr    TEXT;
  _rows         INTEGER;
  _selectstr    TEXT;
  _source       TEXT;
  _record       RECORD;

BEGIN
  IF (poldpkgid = pnewpkgid) THEN
    RETURN 0;
  END IF;

  IF (poldpkgid = -1) THEN
    _source = 'public.uiform';
  ELSE
    SELECT pkghead_name || '.pkguiform' INTO _source
    FROM pkghead
    WHERE pkghead_id=poldpkgid;

    IF NOT FOUND THEN
      RETURN -1;
    END IF;
  END IF;

  IF (pnewpkgid = -1) THEN
    _destination = 'public.uiform';
  ELSE
    SELECT pkghead_name || '.pkguiform' INTO _destination
    FROM pkghead
    WHERE pkghead_id=pnewpkgid;

    IF NOT FOUND THEN
      RETURN -2;
    END IF;
  END IF;

  _selectstr := ' SELECT * FROM ' || _source ||
                ' WHERE uiform_id = ' || puiformid;
  EXECUTE _selectstr INTO _record;

  _deletestr := 'DELETE FROM ONLY ' || _source || 
                ' WHERE uiform_id = ' || puiformid;
  EXECUTE _deletestr;
  GET DIAGNOSTICS _rows = ROW_COUNT;
  RAISE NOTICE '% rows from %', _rows, _deletestr;
  IF (_rows < 1) THEN
    RETURN -3;
  ELSIF (_rows > 1) THEN
    RAISE EXCEPTION 'Tried to delete % uiforms with the id % when there should be exactly 1',
                    _rows, puiformid;
  END IF;

  _insertstr := 'INSERT INTO ' || _destination ||
                ' (uiform_id, uiform_name, uiform_order, uiform_enabled, ' ||
                '  uiform_source, uiform_notes) VALUES ('
                || _record.uiform_id      || ','
                || quote_literal(_record.uiform_name)    || ','
                || _record.uiform_order   || ','
                || _record.uiform_enabled || ','
                || quote_literal(_record.uiform_source)  || ','
                || quote_literal(_record.uiform_notes )  || ');'
                ;
  EXECUTE _insertstr;
  GET DIAGNOSTICS _rows = ROW_COUNT;
  RAISE NOTICE '% rows from %', _rows, _insertstr;
  IF (_rows < 1) THEN
    RETURN -4;
  ELSIF (_rows > 1) THEN
    RAISE EXCEPTION 'Tried to insert % uiforms with the id % when there should be exactly 1',
                    _rows, puiformid;
  END IF;

  IF (pnewpkgid != -1) THEN
    INSERT INTO pkgitem (pkgitem_pkghead_id, pkgitem_type, pkgitem_item_id,
                         pkgitem_name, pkgitem_descrip
    ) SELECT pnewpkgid, 'U', puiformid,
             uiform_name, pkghead_name || ' package - moved from public'
      FROM uiform, pkghead
      WHERE ((uiform_id=puiformid)
          AND (pkghead_id=pnewpkgid));
    GET DIAGNOSTICS _rows = ROW_COUNT;
    RAISE NOTICE '% rows from INSERT INTO pkgitem', _rows;
  END IF;
  
  IF (poldpkgid != -1) THEN
    DELETE FROM pkgitem
    WHERE ((pkgitem_type = 'U')
       AND (pkgitem_item_id=puiformid));
    GET DIAGNOSTICS _rows = ROW_COUNT;
    RAISE NOTICE '% rows from DELETE FROM pkgitem', _rows;
  END IF;

  RETURN puiformid;

END;
$$ LANGUAGE 'plpgsql';
