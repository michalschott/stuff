{%- set password = salt['pillar.get']('pacemaker:password')  %}

hacluster:
  user.present:
    - shell: /bin/nologin
    - home: /home/hacluster
    - password: {{ password }}
