include:
  - drbd.repo
  - drbd.package
  - drbd.config
  - drbd.service

extend:
  drbd_service:
    service:
      - watch:
        - sls: drbd.package
        - sls: drbd.config
      - require:
        - sls: drbd.package
        - sls: drbd.config
  /etc/drbd.d/global_common.conf:
    file.managed:
      - require:
        - sls: drbd.package
  drbd.packages:
    pkg.latest:
      - require:
        - sls: drbd.repo
