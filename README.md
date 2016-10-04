# ansible-util

Manage basic Ansible requirements and provide default configuration
values for roles developed at [Silpion][1].

# Synopsis

```yaml
- name: Maintain basic Ansible requirements
  hosts: all
  roles:
    - role: ansible-util
```

```yaml
- name: Maintain basic Ansible requirements
  hosts: debians
  roles:
    - role: ansible-util
      util_template_use_cow: false
      util_action_become_enable: true
      util_action_become_user: root
      util_action_become_method: sudo
      util_local_action_become_enable: true
      util_local_action_become_user: root
      util_local_action_become_method: sudo
      util_persistent_data_path_local: /path/to/shared/local/directory
      util_persistent_data_path_local_mode: 2777
      util_persistent_data_path_local_owner: shared_user
      util_persistent_data_path_local_group: shared_group
      util_persistent_data_path_remote_mode: 755
      util_persistent_data_path_remote_owner: remote_user
      util_persistent_data_path_remote_group: remote_group
      util_module_get_url_timeout: 12
      util_module_service_manage: true
      util_module_service_allow_reload: true
      util_module_service_allow_restart: true
      util_package_state_debian: installed
      util_package_list_custom:
        - foo
      utiL_apt_cache_valid_time: 3600
```

# Description

Role for base configuration of Ansible roles developed at [Silpion][1].

Any role developed at [Silpion][1] uses util configuration variables
as default for their own variables, e.g. [ansible-java][2] role has
the following default configuration:

* ``java_template_use_cow: "{{ util_template_use_cow|default(true) }}"``

This role further implements common requirements for Ansible itself
and provides earliest access to manage EPEL on RHEL based systems, e.g.
manage SELinux related topics.

# Dependencies

[``silpion.util``][3] role depends on the [``silpion.lib``][4] role. This
is configured for the ``ansible-galaxy install`` command in
**requirements.yml**.

**NOTE**: Ensure ``silpion.lib`` role is getting installed as ``silpion.lib``.
There are hardcoded references to this name.

```sh
# Install silpion.lib role with ansible-galaxy
ansible-galaxy install --role-file requirements.yml
```

# Compatibility

Starting with version ``2.N`` this role drops support for includable
tasks, e.g. ``_get.yml`` or ``_put.yml``. These are now implemented
in ``silpion.lib`` role, which follows being a library better than
this role ever did and ever will.

# Requirements

* privilege escalation

# Role Variables

Mentioned above most of these variables are defined to configure
downstream roles. Any downstream role (regarding ``util`` and ``lib``)
should use defaults based on variables in this roles defaults
configuration. That means:

``silpion.lib`` uses defaults based on ``silpion.util``. Any Silpion role
uses defaults either based on ``lib`` or ``util``, which effectively means
that any role should be configurable with variables from ``silpion.util``.

If this is not the case in downstream roles this is considered a bug
and we are most happy for filed issues or pull requests.

## General configuration

* ``util_template_use_cow``: Whether to add ``{{ ansible_managed }}`` or a fancy cow to templates (boolean, default: ``true``)
* ``util_package_list_custom``: Custom list of packages to be installed (list, default: ``[]``)
* ``util_init_system``: Allow to override init system configuration to be used for service templates (string, default: ``undefined``)
* ``util_path_to_lib_role``: configure path to lib-role, which can get configured via silpion.lib role (string, default: ``{{ lib_roles_path }}``)

### util_init_system

Roles supporting a various number of operating systems and versions do require
to know what init system to configure for services. The ``util_init_system``
variable allows to hardcode that on inventory level for a specific project and
is configured dynamically otherwise, e.g.

- Archlinux: systemd
- CentOS 6: sysvinit
- CentOS 7: systemd
- Ubuntu: upstart
- et cetera

``util_init_system`` value is written to local facts accessable with
``ansible_local.util.init.system``. This fact may get used in
other roles to ease configuration of service management.

The following values are supported (and therefor required):

- ``systemd``
- ``sysvinit``
- ``upstart``

#### init system configuration

Init systems today have different requirements when it comes to service
deployment, e.g. SysV requires init scripts to be executable while
upstart and Systemd discourage this.

util provides the following additional facts for service configuration.

* ``ansible_local.util.init.service_dir``
* ``ansible_local.util.init.service_mode``

These can be configured/hardcoded with the following variables and are
configured dynamicallly otherwise, e.g.

- systemd: /etc/systemd/system with mode 644
- sysvinit: /etc/init.d with mode 755

* ``util_init_service_dir``: Override service directory
* ``util_init_service_mode``: Override service file mode

### action modules

This role makes the ``become`` framework configurable for local\_action
and action modules.

* ``util_action_become_enable``: Whether to use privilege escalation for action modules (boolean, default: ``true``)
* ``util_action_become_user``: Username to escalate privileges to for action modules (string, default: ``root``)
* ``util_action_become_method``: Privileges escalation method to use (string, default: **not in use**)

* ``util_local_action_become_enable``: Whether to use privilege escalation for local\_action modules (boolean, default: ``true``)
* ``util_local_action_become_user``: Username to escalate privileges to for local\_action modules (string, default: ``root``)
* ``util_local_action_become_method``: Privileges escalation method to use (string, default: **not in use**)

### Persistency

Data persistency is now managed in ``silpion.lib`` role, where

* ``tasks/datapersistency.yml`` ensures the required directories being available
* ``tasks/get_url.yml`` can get used to download assets and
* ``tasks/copy.yml`` can get used to upload assets

The following variables are used in ``silpion.lib`` role as defaults
for the persistency paradigma.

#### local

* ``util_persistent_data_path_local``: Where to download data from the internet to the local machine (string, default: ``{{ lookup('env', 'HOME') + '/.ansible/assets' }}``)
* ``util_persistent_data_path_local_owner``: Owner for the local persistent data directory (string, default: ``|default(omit)``)
* ``util_persistent_data_path_local_group``: Group for the local persistent data directory (string, default: ``|default(omit)``)
* ``util_persistent_data_path_local_mode``: Octal access mode for the local persistent data directory (string, default: ``|default(omit)``)

#### remote

* ``util_persistent_data_path_remote``: Where to upload data from the local machine to the managed node (string, default: ``/usr/local/src/ansible/assets``)
* ``util_persistent_data_path_remote_owner``: Owner for the remote persistent data directory (string, default: ``|default(omit)``)
* ``util_persistent_data_path_remote_group``: Group for the remote persistent data directory (string, default: ``|default(omit)``)
* ``util_persistent_data_path_remote_mode``: Octal access mode for the remote persistent data directory (string, default: ``|default(omit)``)

### modules

The following variables are used as global configuration options for
Ansible modules in general.

* ``util_module_get_url_timeout``: Configure ``get_url`` timeout= argument (int, default: ``10``)
* ``util_module_service_manage``: Whether Ansible should manage services with the service module (boolean, default: ``true``)
* ``util_module_service_allow_reload``: Whether Ansible handlers are allowed to reload services (boolean, default: ``true``)
* ``util_module_service_allow_restart``: Whether Ansible handlers are allowed to restart services (boolean, default: ``true``)

### ansible_os_family == 'Debian'

* ``util_apt_cache_valid_time``: Configure apt module cache\_valid\_time parameter (int, default: ``3600``)

### ansible_os_family == 'RedHat'

These variables are used to control EPEL installation on RHEL based
systems.

* ``util_epel_enable``: Whether to enable or disable EPEL repository (boolean, default: ``true``)
* ``util_epel_baseurl``: URL for the EPEL repository (string, default: ``http://download.fedoraproject.org/pub/epel``)

## Local facts

This role distributes various variables as local facts for third party roles to use.

The role tries to discover most of these facts, but they can be manually set using the corresponding variables.
Check variable documentation above for details.

All facts are prefixed with ``ansible_local.util`` so a sample access path could look like this: ``ansible_local.util.init.system``.
The table below omits this prefix.

| Fact name                         | Fact description                               | Variable name                                 | Distributed when                      |
|-----------------------------------|------------------------------------------------|-----------------------------------------------|---------------------------------------|
| ``general.role_version``          | util role version                              | lookup from ``vars/main.yml``                 | always                                |
| ``general.template_use_cow``      | Wether the cow is used for templates           | ``util_template_use_cow``                     | always                                |
| ``general.package_state``         | Desired package state                          | ``util_package_state_{{ ansible_os_family}}`` | always                                |
| ``general.persistent_data_path``  | Persistent data path                           | ``util_persistent_data_path_remote``          | always                                |
| ``init.system``                   | Init system type                               | ``util_init_system``                          | always                                |
| ``init.service_dir``              | Init system service files directory            | ``util_init_service_dir``                     | always                                |
| ``init.service_mode``             | Init system service files mode                 | ``util_init_service_mode``                    | always                                |
| ``modules.get_url.timeout``       | Timeout for the ``get_url`` module             | ``util_module_get_url_timeout``               | always                                |
| ``modules.service.manage``        | Wether the service module may be used          | ``util_module_service_manage``                | always                                |
| ``modules.service.allow_reload``  | Wether the service module may reload services  | ``util_module_service_allow_reload``          | always                                |
| ``modules.serivce.allow_restart`` | Wether the service module may restart services | ``util_module_service_allow_restart``         | always                                |
| ``epel.enabled``                  | Wether EPEL is enabled on this system          | ``util_epel_enable``                          | ``{{ ansible_os_family }} == RedHat`` |
| ``modules.apt.cache_valid_time``  | Apt cache valid time                           | ``util_apt_cache_valid_time``                 | ``{{ ansible_os_family }} == Debian`` |


## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: ansible-util
```

## License

Apache Version 2.0

## Integration testing

This role provides integration tests using the Ruby RSpec/serverspec framework
with a few drawbacks at the time of writing this documentation.

- Currently supports ansible\_os\_family == 'Debian' only.

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


[1]: http://silpion.de
[2]: https://github.com/silpion/ansible-java
[3]: https://github.com/silpion/ansible-util
[4]: https://github.com/silpion/ansible-lib


<!-- vim: set nofen ts=4 sw=4 et: -->
