goss_tests_goss:
  file.managed:
    - name: /opt/goss/goss.yaml
    - source: salt://goss/files/tests/goss.yaml
    - template: jinja
    - user: root
    - group: root
    - mode: "0640"

goss_tests_base:
  file.managed:
    - name: /opt/goss/base.yaml
    - source: salt://goss/files/tests/base.yaml
    - user: root
    - group: root
    - mode: "0640"

goss_tests_role:
  file.managed:
    - name: /opt/goss/{{ grains['role'] }}.yaml
    - source:
      - salt://goss/files/tests/{{ grains['role'] }}.yaml
    - user: root
    - group: root
    - mode: "0640"
    - template: jinja

goss_tests_role_env:
  file.managed:
    - name: /opt/goss/{{ grains['role'] }}-{{ grains['env_name'] }}.yaml
    - source:
      - salt://goss/files/tests/{{ grains['env_name'] }}/{{ grains['role'] }}.yaml
    - user: root
    - group: root
    - mode: "0640"
    - template: jinja
