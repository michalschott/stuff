{%- from "nfs/map.jinja" import nfs with context %}
{%- set domain = salt['pillar.get']('nfs:domain', '') %}
nfs_packages:
  pkg.installed:
    - name: nfs-utils

idmapd_conf:
  file.managed:
    - name: /etc/idmapd.conf
    - owner: root
    - group: root
    - mode: "0755"
    - source: 'salt://nfs/files/idmapd.conf'
    - template: jinja
    - context:
        domain: {{ domain }}

rpcbind_service:
  service.dead:
    - name: rpcbind
    - enable: true
