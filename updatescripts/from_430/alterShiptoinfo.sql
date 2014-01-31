ALTER TABLE shiptoinfo ADD COLUMN shipto_preferred_warehous_id INTEGER;

UPDATE shiptoinfo SET shipto_preferred_warehous_id=-1;

ALTER TABLE shiptoinfo ALTER COLUMN shipto_preferred_warehous_id SET DEFAULT -1;
ALTER TABLE shiptoinfo ALTER COLUMN shipto_preferred_warehous_id SET NOT NULL;

