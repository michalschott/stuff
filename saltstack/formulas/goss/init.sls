include:
  - goss.package
{%- if grains['role'] != 'base' and grains['env_name'] != 'base' %}
  - goss.config
  - goss.service

extend:
  goss_service:
    service:
      - watch:
        - sls: goss.package
        - sls: goss.config
      - require:
        - sls: goss.package
        - sls: goss.config
{%- endif %}
