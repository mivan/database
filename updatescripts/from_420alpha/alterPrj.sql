ALTER TABLE prj ADD COLUMN prj_prjtype_id integer,
  ADD CONSTRAINT prj_prj_prjtype_id_fkey FOREIGN KEY (prj_prjtype_id)
      REFERENCES prjtype (prjtype_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
