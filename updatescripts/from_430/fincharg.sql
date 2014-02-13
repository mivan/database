SELECT dropIfExists('TABLE', 'fincharg');

CREATE TABLE fincharg
(
  fincharg_id serial primary key,
  fincharg_mincharg numeric NOT NULL,
  fincharg_graceperiod integer NOT NULL,
  fincharg_assessoverdue boolean NOT NULL,
  fincharg_calcfrom integer NOT NULL,
  fincharg_markoninvoice text NOT NULL,
  fincharg_air numeric NOT NULL,
  fincharg_accnt_id integer NOT NULL,
  fincharg_salescat_id integer NOT NULL,
  fincharg_lastfc_statementcyclefrom text,
  fincharg_lastfc_custidfrom text,
  fincharg_lastfc_custidto text,
  fincharg_lastfc_statementcycleto text
);

GRANT ALL ON TABLE fincharg TO xtrole;
GRANT ALL ON SEQUENCE fincharg_fincharg_id_seq TO xtrole;
COMMENT ON TABLE fincharg IS 'Finance Charge configuration information';
