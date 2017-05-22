{%- from "autofs/map.jinja" import autofs with context %}
autofs_package:
  pkg.installed:
    - name: autofs

autofs_auto_master:
  file.managed:
    - name: /etc/auto.master
    - owner: root
    - group: root
    - mode: '0644'
    - source: salt://autofs/files/auto.master

autofs_auto_mount:
  file.managed:
    - name: /etc/auto.mount
    - owner: root
    - group: root
    - mode: '0640'

{%- for mount_name, params in autofs.items() %}
mount_dir_autofs_{{mount_name |replace('/', '_') }}:
  file.directory:
    - name: {{ mount_name }}
    - owner: {{ params.uid }}
    - group: {{ params.gid }}
    - mode: '0755'

mount_autofs_{{ mount_name |replace('/', '_') }}:
  file.append:
    - name: '/etc/auto.mount'
    - source: salt://autofs/files/auto.mount
    - template: jinja
    - context:
        local_dir: {{ mount_name }}
        remote_server: {{ params.remote_server }}
        remote_dir: {{ params.remote_dir }}
        fstype: {{ params.fstype}}
{%- endfor %}

autofs_service:
  service.dead:
    - name: autofs
    - enable: true
