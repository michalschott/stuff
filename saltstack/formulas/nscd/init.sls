nscd_pkg:
  pkg.installed:
    - pkgs:
      - nscd

nscd_config:
  file.managed:
    - name: /etc/nscd.conf
    - owner: root
    - group: root
    - mode: "0644"
    - source: salt://nscd/files/nscd.conf
    - template: jinja

nscd_service:
  service.dead:
    - name: nscd
    - enable: True
