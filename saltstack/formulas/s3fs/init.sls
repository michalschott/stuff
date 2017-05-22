{%- from "s3fs/map.jinja" import s3fs with context %}
install_s3_fs:
  pkg.installed:
    - name: s3fs-fuse

{%- for mount_name, params in s3fs.items() %}
mount_dir_s3fs_{{params.bucket_name |replace('-', '_') }}:
  file.directory:
    - name: {{ mount_name }}
    - owner: root
    - group: root
    - mode: '0755'

mount_s3fs_{{ params.bucket_name |replace('-', '_') }}:
  file.append:
    - name: '/etc/fstab'
    - source: salt://s3fs/files/fstab_append
    - template: jinja
    - context:
        bucket_name: {{ params.bucket_name }}
        mount_name: {{ mount_name }}
        aws_role: {{ params.aws_role }}
{%- endfor %}
