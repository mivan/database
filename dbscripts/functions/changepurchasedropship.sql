CREATE OR REPLACE FUNCTION changePurchaseDropShip(pCoitemId INTEGER,
                                                  pPoitemId INTEGER,
                                                  pDropShip BOOLEAN) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2012 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _s RECORD;
  _w RECORD;
  _p RECORD;
 

BEGIN

  -- Check for existing poitem for this coitem
  SELECT * INTO _p
  FROM poitem JOIN pohead ON (pohead_id=poitem_pohead_id)
  WHERE (poitem_id=pPoitemId)
    AND (poitem_order_id=pCoitemId)
    AND (poitem_order_type='S');
  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'Change Purchase Drop Ship PO not found';
  END IF;

  SELECT * INTO _s
  FROM coitem JOIN cohead ON (cohead_id = coitem_cohead_id)
    LEFT OUTER JOIN shiptoinfo ON (cohead_shipto_id = shipto_id)
    LEFT OUTER JOIN cntct ON (shipto_cntct_id = cntct_id)
    LEFT OUTER JOIN addr ON (shipto_addr_id = addr_id)
  WHERE (coitem_id = pCoitemId);
  IF (NOT FOUND) THEN
    RETURN -1;
  END IF;

  SELECT * INTO _w
  FROM itemsite JOIN whsinfo ON (warehous_id=itemsite_warehous_id)
    JOIN addr ON (warehous_addr_id = addr_id)
    JOIN cntct ON (warehous_cntct_id = cntct_id)
  WHERE (itemsite_id = _s.coitem_itemsite_id);
  IF (NOT FOUND) THEN
    RETURN -2;
  END IF;

  IF (_p.pohead_status != 'U') THEN
    RETURN -3;
  END IF;

  IF (pDropShip) THEN
    UPDATE pohead SET
          pohead_dropship=true,
          pohead_shipto_cntct_id=_s.cohead_shipto_cntct_id,
          pohead_shipto_cntct_honorific=_s.cohead_shipto_cntct_honorific,
          pohead_shipto_cntct_first_name=_s.cohead_shipto_cntct_first_name,
          pohead_shipto_cntct_middle=_s.cohead_shipto_cntct_middle,
          pohead_shipto_cntct_last_name=_s.cohead_shipto_cntct_last_name,
          pohead_shipto_cntct_suffix=_s.cohead_shipto_cntct_suffix,
          pohead_shipto_cntct_phone=_s.cohead_shipto_cntct_phone,
          pohead_shipto_cntct_title=_s.cohead_shipto_cntct_title,
          pohead_shipto_cntct_fax=_s.cohead_shipto_cntct_fax, 
          pohead_shipto_cntct_email=_s.cohead_shipto_cntct_email,
          pohead_shiptoaddress_id=_s.shipto_addr_id,
          pohead_shiptoaddress1=_s.cohead_shiptoaddress1,
          pohead_shiptoaddress2=_s.cohead_shiptoaddress2,
          pohead_shiptoaddress3=_s.cohead_shiptoaddress3,
          pohead_shiptocity=_s.cohead_shiptocity, 
          pohead_shiptostate=_s.cohead_shiptostate,
          pohead_shiptozipcode=_s.cohead_shiptozipcode,
          pohead_shiptocountry=_s.cohead_shiptocountry
    WHERE (pohead_id=_p.pohead_id);
  ELSE
    UPDATE pohead SET
          pohead_dropship=false,
          pohead_shipto_cntct_id=_w.cntct_id,
          pohead_shipto_cntct_honorific=_w.cntct_honorific,
          pohead_shipto_cntct_first_name=_w.cntct_first_name,
          pohead_shipto_cntct_middle=_w.cntct_middle,
          pohead_shipto_cntct_last_name=_w.cntct_last_name,
          pohead_shipto_cntct_suffix=_w.cntct_suffix,
          pohead_shipto_cntct_phone=_w.cntct_phone,
          pohead_shipto_cntct_title=_w.cntct_title,
          pohead_shipto_cntct_fax=_w.cntct_fax, 
          pohead_shipto_cntct_email=_w.cntct_email,
          pohead_shiptoaddress_id=_w.addr_id,
          pohead_shiptoaddress1=_w.addr_line1,
          pohead_shiptoaddress2=_w.addr_line2,
          pohead_shiptoaddress3=_w.addr_line3,
          pohead_shiptocity=_w.addr_city, 
          pohead_shiptostate=_w.addr_state,
          pohead_shiptozipcode=_w.addr_postalcode,
          pohead_shiptocountry=_w.addr_country
    WHERE (pohead_id=_p.pohead_id);
  END IF;

  RETURN 0;

END;
$$ LANGUAGE 'plpgsql' VOLATILE;
