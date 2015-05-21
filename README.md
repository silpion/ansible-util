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

### action modules

As of ansible ``1.9.`` the become framework has been integrated into mainline.
This role makes the become framework configurable for local_action and action
modules.

As of ansible ``1.9.`` the keywords

* become
* become_user
* become_method
* sudo
* sudo_user

do not allow to be configured dynamically with variables, e.g.

    - name: I am some task
      become: "{{ util_action_become_enable }}"
      become_user: "{{ util_action_become_user|default('root') }}"
      become_method: "{{ util_action_become_method|default('sudo') }}"
      action: file
        state=absent
        dest=/tmp/foo

results in an internal error, because there is no variable substitution
taking place. Configuring sudo and sudo_user arguments does not escalate
privileges if util_action_become_enable is configured boolean true.


I consider this a bug in ansible which is fixed for ``v2``.


Anyway the following variables might get configured, but until ansible ``v2``
comes around the roles (including this one) will still use hardcoded sudo
configuration.

* ``util_action_become_enable``: Whether to use sudo for action modules (boolean, default: ``true``)
* ``util_action_become_user``: Username to escalate privileges to for action modules (string, default: ``root``)
* ``util_action_become_method``: Privileges escalation method to use (string, default: **not in use**)
* ``util_local_action_become_enable``: Whether to use sudo for local\_action modules (boolean, default: ``true``)
* ``util_local_action_become_user``: Username to escalate privileges to for local\_action modules (string, default: ``root``)
* ``util_local_action_become_method``: Privileges escalation method to use (string, default: **not in use**)

#### Backward compatibility

The following variables reside for backward compatibility and will get
removed in future releases. These variables currently do not have any
effect (see action modules documentation above).

* ``util_local_action_sudo_enable``: Whether to run local_action with sudo: true (boolean, default: ``true``)
* ``util_local_action_sudo_user``: Configure sudo\_user argument to local\_action tasks (string, default: ``|default(omit)``)

### Persistency

* ``util_persistent_data_path_local``: Where to download data from the internet to the local machine (string, default: ``{{ lookup('env', 'HOME') + '/.ansible/assets' }}``)
* ``util_persistent_data_path_local_owner``: Owner for the local persistent data directory (string, default: ``|default(omit)``)
* ``util_persistent_data_path_local_group``: Group for the local persistent data directory (string, default: ``|default(omit)``)
* ``util_persistent_data_path_local_mode``: Octal access mode for the local persistent data directory (string, default: ``|default(omit)``)
* ``util_persistent_data_path_remote``: Where to upload data from the local machine to the managed node (string, default: ``/usr/local/src/ansible/assets``)

### action: "{{ ansible_pkg_mgr }}"

* ``util_package_state_archlinux``: Configure pacman module state parameter (string, default: ``present``)
* ``util_package_state_redhat``: Configure yum module state parameter (string, default: ``present``)
* ``util_package_state_debian``: Configure apt module state paremeter (string, default: ``installed``)

### modules

* ``util_module_get_url_timeout``: Configure get_url timeout= argument (int, default: ``10``)

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
