SELECT dropIfExists('FUNCTION', 'araging(date)', 'public');

CREATE OR REPLACE FUNCTION araging(date, boolean) RETURNS SETOF araging AS $$
DECLARE
  pAsOfDate ALIAS FOR $1;
  pUseDocDate ALIAS FOR $2;
  _row araging%ROWTYPE;
  _x RECORD;
  _returnVal INTEGER;
  _asOfDate DATE;
BEGIN

  _asOfDate := COALESCE(pAsOfDate,current_date);

  FOR _x IN
        SELECT
        --report uses currtobase to convert all amounts to base based on aropen_docdate to ensure the same exchange rate

        --today and greater base:
        CASE WHEN((aropen_duedate >= DATE(_asOfDate))) 
        THEN (((aropen_amount-aropen_paid+COALESCE(SUM(arapply_target_paid),0)))/aropen_curr_rate *
        CASE WHEN (aropen_doctype IN ('C', 'R')) THEN -1 ELSE 1 END) ELSE 0 END AS cur_val,

        --0 to 30 base
        CASE WHEN((aropen_duedate >= DATE(_asOfDate)-30) AND (aropen_duedate < DATE(_asOfDate)))
        THEN (((aropen_amount-aropen_paid+COALESCE(SUM(arapply_target_paid),0)))/aropen_curr_rate *
        CASE WHEN (aropen_doctype IN ('C', 'R')) THEN -1 ELSE 1 END) ELSE 0 END AS thirty_val,

        --30-60 base
        CASE WHEN((aropen_duedate >= DATE(_asOfDate)-60) AND (aropen_duedate < DATE(_asOfDate) - 30 ))
        THEN (((aropen_amount-aropen_paid+COALESCE(SUM(arapply_target_paid),0)))/aropen_curr_rate *
        CASE WHEN (aropen_doctype IN ('C', 'R')) THEN -1 ELSE 1 END) ELSE 0 END AS sixty_val,

        --60-90 base
        CASE WHEN((aropen_duedate >= DATE(_asOfDate)-90) AND (aropen_duedate < DATE(_asOfDate) - 60))
        THEN (((aropen_amount-aropen_paid+COALESCE(SUM(arapply_target_paid),0)))/aropen_curr_rate *
        CASE WHEN (aropen_doctype IN ('C', 'R')) THEN -1 ELSE 1 END) ELSE 0 END AS ninety_val,

        --greater than 90 base:
        CASE WHEN((aropen_duedate > DATE(_asOfDate)-10000) AND (aropen_duedate < DATE(_asOfDate) - 90))
        THEN (((aropen_amount-aropen_paid+COALESCE(SUM(arapply_target_paid),0)))/aropen_curr_rate *
        CASE WHEN (aropen_doctype IN ('C', 'R')) THEN -1 ELSE 1 END) ELSE 0 END AS plus_val,

        --total amount base:
        CASE WHEN((aropen_duedate > DATE(_asOfDate)-10000)) 
        THEN (((aropen_amount-aropen_paid+COALESCE(SUM(arapply_target_paid),0)))/aropen_curr_rate *
        CASE WHEN (aropen_doctype IN ('C', 'R')) THEN -1 ELSE 1 END) ELSE 0 END AS total_val,

        --AR Open Amount base
        CASE WHEN aropen_doctype IN ('C', 'R') 
        THEN (aropen_amount * -1) / aropen_curr_rate
        ELSE aropen_amount / aropen_curr_rate END AS aropen_amount,

        aropen_docdate,
        aropen_duedate,
        aropen_ponumber,
        aropen_docnumber,
        aropen_doctype,
        cust_id,
        cust_name,
        cust_number,
        cust_custtype_id,
        custtype_code,
        terms_descrip

        FROM custinfo, custtype, aropen
          LEFT OUTER JOIN terms ON (aropen_terms_id=terms_id)
          LEFT OUTER JOIN arapply ON (((aropen_id=arapply_target_aropen_id)
                                    OR (aropen_id=arapply_source_aropen_id))
                                   AND (arapply_distdate>_asOfDate))
        WHERE ( (aropen_cust_id = cust_id)
        AND (cust_custtype_id=custtype_id)
        AND (CASE WHEN (pUseDocDate) THEN aropen_docdate ELSE aropen_distdate END <= _asOfDate)
        AND (COALESCE(aropen_closedate,_asOfDate+1)>_asOfDate) )
        GROUP BY aropen_id,aropen_docdate,aropen_duedate,aropen_ponumber,aropen_docnumber,aropen_doctype,aropen_paid,
                 aropen_curr_id,aropen_amount,cust_id,cust_name,cust_number,cust_custtype_id,custtype_code,terms_descrip,
                 aropen_curr_rate
        ORDER BY cust_number, aropen_duedate
  LOOP
        _row.araging_docdate := _x.aropen_docdate;
        _row.araging_duedate := _x.aropen_duedate;
        _row.araging_ponumber := _x.aropen_ponumber;
        _row.araging_docnumber := _x.aropen_docnumber;
        _row.araging_doctype := _x.aropen_doctype;
        _row.araging_cust_id := _x.cust_id;
        _row.araging_cust_number := _x.cust_number;
        _row.araging_cust_name := _x.cust_name;
        _row.araging_cust_custtype_id := _x.cust_custtype_id;
        _row.araging_custtype_code := _x.custtype_code;
        _row.araging_terms_descrip := _x.terms_descrip;
        _row.araging_aropen_amount := _x.aropen_amount;
        _row.araging_cur_val := _x.cur_val;
        _row.araging_thirty_val := _x.thirty_val;
        _row.araging_sixty_val := _x.sixty_val;
        _row.araging_ninety_val := _x.ninety_val;
        _row.araging_plus_val := _x.plus_val;
        _row.araging_total_val := _x.total_val;
        RETURN NEXT _row;
  END LOOP;
  RETURN;
END;
$$ LANGUAGE 'plpgsql';
