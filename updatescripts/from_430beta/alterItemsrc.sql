ALTER TABLE itemsrc ADD COLUMN itemsrc_contrct_max NUMERIC(18,6) NOT NULL DEFAULT 0.0;
ALTER TABLE itemsrc ADD COLUMN itemsrc_contrct_min NUMERIC(18,6) NOT NULL DEFAULT 0.0;

ALTER TABLE itemsrc DROP CONSTRAINT itemsrc_itemsrc_vend_id_key;

ALTER TABLE itemsrc
  ADD CONSTRAINT itemsrc_itemsrc_vend_id_key UNIQUE(itemsrc_vend_id , itemsrc_item_id , itemsrc_effective , itemsrc_expires , itemsrc_vend_item_number , itemsrc_manuf_name , itemsrc_manuf_item_number , itemsrc_contrct_id );

DROP TABLE IF EXISTS contisrc;