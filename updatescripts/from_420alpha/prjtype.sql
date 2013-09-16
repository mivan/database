CREATE TABLE prjtype
(
  prjtype_id serial NOT NULL,
  prjtype_code text,
  prjtype_descr text,
  prjtype_active boolean DEFAULT true,
  CONSTRAINT pk_prjtype PRIMARY KEY (prjtype_id ),
  CONSTRAINT unq_prjtype_code UNIQUE (prjtype_code )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE prjtype
  OWNER TO admin;
GRANT ALL ON TABLE prjtype TO admin;
GRANT ALL ON TABLE prjtype TO xtrole;
