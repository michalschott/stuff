goss_install:
  cmd.run:
    - name: curl -fsSL https://goss.rocks/install | sh
    - creates: /usr/local/bin/goss

goss_systemd:
  file.managed:
    - name: /etc/systemd/system/goss.service
    - source: salt://goss/files/goss.service
    - user: root
    - group: root
    - mode: "0750"
    - template: jinja

goss_dir:
  file.directory:
    - name: /opt/goss
    - user: root
    - group: root
    - mode: "0640"

goss_wrapper:
  file.managed:
    - name: /opt/goss/goss.sh
    - source: salt://goss/files/goss.sh
    - user: root
    - group: root
    - mode: "0750"
