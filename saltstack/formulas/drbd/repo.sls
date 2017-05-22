elrepo:
  pkg.installed:
    - sources:
      - elrepo-release: http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
    - unless: rpm -q elrepo-release
