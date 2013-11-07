-- Table: contisrc

-- DROP TABLE contisrc;

CREATE TABLE contisrc
(
  contisrc_id serial NOT NULL,
  contisrc_itemsrc_id integer,
  contisrc_max integer,
  contisrc_min integer,
  CONSTRAINT contisrc_pkey PRIMARY KEY (contisrc_id ),
  CONSTRAINT contisrc_contisrc_itemsrc_id_fkey FOREIGN KEY (contisrc_itemsrc_id)
      REFERENCES itemsrc (itemsrc_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE contisrc
  OWNER TO admin;
GRANT ALL ON TABLE contisrc TO admin;
GRANT ALL ON TABLE contisrc TO xtrole;
