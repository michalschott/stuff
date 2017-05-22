{%- from "nfs/map.jinja" import nfs with context %}

include:
  - autofs
  - nfs.common

nfs_exports:
  file.managed:
    - name: /etc/exports
    - owner: root
    - group: root
    - mode: '0750'

{%- for export, params in nfs.exports.items() %}
nfs_export_dir_{{export |replace('/', '_') }}:
  file.directory:
    - name: {{ export }}
    - owner: 'root'
    - group: 'root'
    - mode: '0755'
nfs_export_{{export |replace('/', '_') }}:
  file.append:
    - name: '/etc/exports'
    - source: salt://nfs/files/exports
    - template: jinja
    - context:
        export: {{ export }}
        subnet: {{ params.subnet }}
        options: {{ params.options }}
{%- endfor %}

nfs_service_unit:
  file.managed:
    - name: /usr/lib/systemd/system/nfs-server.service
    - owner: 'root'
    - group: 'root'
    - mode: '0755'
    - source: salt://nfs/files/nfs-server.service

nfs_systemctl_reload:
  cmd.run:
    - name: systemctl daemon-reload

nfs_server_service:
  service.dead:
    - name: nfs-server
    - enable: true
