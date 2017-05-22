include:
  - pacemaker.package
  - pacemaker.config
  - pacemaker.service

extend:
  pacemaker_service:
    service:
      - watch:
        - sls: pacemaker.package
        - sls: pacemaker.config
      - require:
        - sls: pacemaker.package
        - sls: pacemaker.config
  hacluster:
    user.present:
      - require:
        - sls: pacemaker.package
