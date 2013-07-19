CREATE TABLE fincharg
(
  fincharg_id integer NOT NULL,
  fincharg_mincharg double precision NOT NULL,
  fincharg_graceperiod integer NOT NULL,
  fincharg_assessoverdue boolean NOT NULL,
  fincharg_calcfrom integer NOT NULL,
  fincharg_markoninvoice text NOT NULL,
  fincharg_air text,
  fincharg_glaccnt integer,
  fincharg_lastfc_statementcyclefrom character(5),
  fincharg_lastfc_custidfrom text,
  fincharg_lastfc_custidto text,
  fincharg_lastfc_statementcycleto character(5),
  CONSTRAINT "PRIMARY_fincharge_id" PRIMARY KEY (fincharg_id )
)
WITH (
  OIDS=FALSE
);