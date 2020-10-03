FROM oracle/database:19.3.0-ee

ENV ORACLE_SID=ORCLCDB
ENV ORACLE_PDB=ORCLPDB1

COPY setup/*   /opt/oracle/scripts/setup/
COPY startup/* /opt/oracle/scripts/startup/