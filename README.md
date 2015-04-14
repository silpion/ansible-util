# ansible-util

Role for base configuration of Ansible roles developed at Silpion.


This role implements commen requirements for Ansible itself and
a persistency paradigm for down- and uploaded data in particular.

Target is to reduce redundancy in Ansible role code and to have
a single point of dependency in terms of Ansible requirements/
dependencies.

## Requirements

None.

## Role Variables

* ``util_template_use_cow``: Whether to add {{ ansible_managed }} or a fancy cow to templates (boolean, default: ``true``)
* ``util_package_list_custom``: Custom list of packages to be installed (list, default: ``[]``)

### local_action

* ``util_local_action_sudo_enable``: Whether to run local_action with sudo: yes (boolean, default: ``yes``)
* ``util_local_action_sudo_user``: Configure sudo\_user argument to local\_action tasks (string, default: ``|default(omit)``)

### Persistency

* ``util_persistent_data_path_local``: Where to download data from the internet to the local machine (string, default: ``/usr/local/src/ansible/data``)
* ``util_persistent_data_path_local_owner``: Owner for the local persistent data directory (string, default: ``|default(omit)``)
* ``util_persistent_data_path_local_group``: Group for the local persistent data directory (string, default: ``|default(omit)``)
* ``util_persistent_data_path_local_mode``: Octal access mode for the local persistent data directory (string, default: ``|default(omit)``)
* ``util_persistent_data_path_local_remote``: Where to upload data from the local machine to the managed node (string, default: ``/usr/local/src/ansible/data``)

### action: "{{ ansible_pkg_mgr }}"

* ``util_package_state_archlinux``: Configure pacman module state parameter (string, default: ``present``)
* ``util_package_state_redhat``: Configure yum module state parameter (string, default: ``present``)
* ``util_package_state_debian``: Configure apt module state paremeter (string, default: ``installed``)

### ansible_os_family == 'Debian'

* ``util_apt_cache_valid_time``: Configure apt module cache_valid_time parameter (int, default: ``3600``)

### ansible_os_family == 'RedHat'

* ``util_epel_enable``: Whether to enable or disable EPEL repository (boolean, default: ``true``)
* ``util_epel_version``: EPEL repository version to install (int, default: ``6``)
* ``util_epel_baseurl``: URL for the EPEL repository (string, default: ``http://download.fedoraproject.org/pub/epel``)
* ``util_epel_mirrorurl``: Mirror for the EPEL repository (string, default: ``https://mirrors.fedoraproject.org/metalink``)
* ``util_epel_enable_debug``: Whether to enable EPEL debug packages repository (boolean, default: ``false``)
* ``util_epel_enable_source``: Whether to enable EPEL source packages repository (boolean, default: ``false``)

## Dependencies

None.

## Example Playbook

    - hosts: all
      roles:
         - { role: ansible-util }

## License

Apache Version 2.0

## Integration testing

This role provides integration tests using the Ruby RSpec/serverspec framework
with a few drawbacks at the time of writing this documentation.

- Currently supports ansible_os_family == 'Debian' only.

Running integration tests requires a number of dependencies being
installed. As this role uses Ruby RSpec there is the need to have
Ruby with rake and bundler available.

    # install role specific dependencies with bundler
    bundle install

<!-- -->

    # run the complete test suite with Docker
    rake suite

<!-- -->

    # run the complete test suite with Vagrant
    RAKE_ANSIBLE_USE_VAGRANT=1 rake suite


## Author information

Mark Kusch @silpion.de mark.kusch


<!-- vim: set nofen ts=4 sw=4 et: -->
