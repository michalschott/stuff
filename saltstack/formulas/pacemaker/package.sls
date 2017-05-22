pacemaker.packages:
  pkg.latest:
    - pkgs:
      - pcs
      - policycoreutils-python

hearthbeat-anything:
  cmd.run:
    - name: curl -o anything https://raw.githubusercontent.com/ClusterLabs/resource-agents/master/heartbeat/anything && chmod 755 anything
    - cwd: /usr/lib/ocf/resource.d/heartbeat
    - unless: test -e anything
  file.managed:
    - name: /usr/lib/ocf/resource.d/heartbeat/anything
    - mode: '0755'
    - user: root
    - group: root
    - replace: false
    - require:
      - cmd: hearthbeat-anything
