-- Table: itemsrc

-- DROP TABLE itemsrc;

CREATE TABLE itemsrc
(
  itemsrc_id integer NOT NULL DEFAULT nextval(('"itemsrc_itemsrc_id_seq"'::text)::regclass),
  itemsrc_item_id integer NOT NULL,
  itemsrc_vend_id integer NOT NULL,
  itemsrc_vend_item_number text,
  itemsrc_vend_item_descrip text,
  itemsrc_comments text,
  itemsrc_vend_uom text NOT NULL,
  itemsrc_invvendoruomratio numeric(20,10) NOT NULL,
  itemsrc_minordqty numeric(18,6) NOT NULL,
  itemsrc_multordqty numeric(18,6) NOT NULL,
  itemsrc_leadtime integer NOT NULL,
  itemsrc_ranking integer NOT NULL,
  itemsrc_active boolean NOT NULL,
  itemsrc_manuf_name text NOT NULL DEFAULT ''::text,
  itemsrc_manuf_item_number text NOT NULL DEFAULT ''::text,
  itemsrc_manuf_item_descrip text,
  itemsrc_default boolean,
  itemsrc_upccode text,
  itemsrc_effective date NOT NULL DEFAULT startoftime(), -- Effective date for item source.  Constraint for overlap.
  itemsrc_expires date NOT NULL DEFAULT endoftime(), -- Expiration date for item source.  Constraint for overlap.
  itemsrc_contrct_id integer, -- Associated contract for item source.  Inherits effective, expiration dates.
  CONSTRAINT itemsrc_pkey PRIMARY KEY (itemsrc_id ),
  CONSTRAINT itemsrc_itemsrc_contrct_id_fkey FOREIGN KEY (itemsrc_contrct_id)
      REFERENCES contrct (contrct_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT itemsrc_itemsrc_item_id_fkey FOREIGN KEY (itemsrc_item_id)
      REFERENCES item (item_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT itemsrc_itemsrc_vend_id_fkey FOREIGN KEY (itemsrc_vend_id)
      REFERENCES vendinfo (vend_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT itemsrc_itemsrc_vend_id_key UNIQUE (itemsrc_vend_id , itemsrc_item_id , itemsrc_effective , itemsrc_expires , itemsrc_vend_item_number , itemsrc_manuf_name , itemsrc_manuf_item_number , itemsrc_contrct_id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE itemsrc
  OWNER TO admin;
GRANT ALL ON TABLE itemsrc TO admin;
GRANT ALL ON TABLE itemsrc TO xtrole;
COMMENT ON TABLE itemsrc
  IS 'Item Source information';
COMMENT ON COLUMN itemsrc.itemsrc_effective IS 'Effective date for item source.  Constraint for overlap.';
COMMENT ON COLUMN itemsrc.itemsrc_expires IS 'Expiration date for item source.  Constraint for overlap.';
COMMENT ON COLUMN itemsrc.itemsrc_contrct_id IS 'Associated contract for item source.  Inherits effective, expiration dates.';


-- Index: itemsrc_vend_id_idx

-- DROP INDEX itemsrc_vend_id_idx;

CREATE INDEX itemsrc_vend_id_idx
  ON itemsrc
  USING btree
  (itemsrc_vend_id );


-- Trigger: itemsrcaftertrigger on itemsrc

-- DROP TRIGGER itemsrcaftertrigger ON itemsrc;

CREATE TRIGGER itemsrcaftertrigger
  AFTER INSERT OR UPDATE
  ON itemsrc
  FOR EACH ROW
  EXECUTE PROCEDURE _itemsrcaftertrigger();

-- Trigger: itemsrctrigger on itemsrc

-- DROP TRIGGER itemsrctrigger ON itemsrc;

CREATE TRIGGER itemsrctrigger
  BEFORE INSERT OR UPDATE
  ON itemsrc
  FOR EACH ROW
  EXECUTE PROCEDURE _itemsrctrigger();

