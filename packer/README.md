# Vagrant

```
packer build \
  -only vagrant \
  centos-7.3-minimal.json
```

# AWS AMI

```
packer build \
  -only aws \
  -var 'aws_access_key=' \
  -var 'aws_secret_key=' \
  -var 'aws_region=' \
  -var 'aws_s3_bucket=' \
  centos-7.3-minimal.json
```

# Notes

Default root password is `root_password`.
