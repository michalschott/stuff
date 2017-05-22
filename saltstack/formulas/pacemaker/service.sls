pacemaker_service:
  service.running:
    - name: pcsd
    - enable: True
    - reload: True
