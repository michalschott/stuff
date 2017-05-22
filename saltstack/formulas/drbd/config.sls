/etc/drbd.d/global_common.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0640'
    - source: salt://drbd/files/global_common.conf

selinux_drbd:
  cmd.run:
    - name: semanage permissive -a drbd_t
