-- this should be deleted


ALTER TABLE itemsrc DROP CONSTRAINT itemsrc_itemsrc_vend_id_key;

ALTER TABLE itemsrc
  ADD CONSTRAINT itemsrc_itemsrc_vend_id_key UNIQUE(itemsrc_vend_id , itemsrc_item_id , itemsrc_effective , itemsrc_expires , itemsrc_vend_item_number , itemsrc_manuf_name , itemsrc_manuf_item_number , itemsrc_contrct_id );
