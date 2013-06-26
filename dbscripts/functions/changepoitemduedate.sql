CREATE OR REPLACE FUNCTION changePoitemDueDate(pPoitemid INTEGER,
                                               pDate DATE) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2012 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  RETURN changePoitemDueDate(pPoitemid, pDate, false);

END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION changePoitemDueDate(pPoitemid INTEGER,
                                               pDate DATE,
                                               pBySO BOOLEAN) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2012 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  IF ( ( SELECT (poitem_status IN ('C'))
         FROM poitem
         WHERE (poitem_id=pPoitemid) ) ) THEN
    RETURN -1;
  END IF;

  UPDATE poitem
  SET poitem_duedate=pDate
  WHERE (poitem_id=pPoitemid);

  IF (pBySO) THEN
    --Generate the PoItemUpdatedBySo event
    INSERT INTO evntlog
                ( evntlog_evnttime, evntlog_username, evntlog_evnttype_id,
                  evntlog_ordtype, evntlog_ord_id, evntlog_warehous_id,
                  evntlog_number )
    SELECT CURRENT_TIMESTAMP, evntnot_username, evnttype_id,
           'P', poitem_id, itemsite_warehous_id,
            (pohead_number || '-'|| poitem_linenumber || ': ' || item_number)
    FROM evntnot JOIN evnttype ON (evntnot_evnttype_id=evnttype_id)
                 JOIN itemsite ON (evntnot_warehous_id=itemsite_warehous_id)
                 JOIN item ON (itemsite_item_id=item_id)
                 JOIN poitem ON (poitem_itemsite_id=itemsite_id)
                 JOIN pohead ON (poitem_pohead_id=pohead_id)
            WHERE( (poitem_id=pPoitemid)
            AND (poitem_duedate <= (CURRENT_DATE + itemsite_eventfence))
            AND (evnttype_name='PoItemUpdatedBySo') );
  END IF;

  RETURN pPoitemid;

END;
$$ LANGUAGE 'plpgsql';
