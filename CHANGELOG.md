# 0.4.0

Mark Kusch (19):

* Provide description to test playbook
* Prepare defaults to configure become framework
* Document privilege escalation configuration and bugs
* Cleanup vagrant environment
* Add boilerplate variables according to documentation
* Hardcode sudo for variable substitution bug reasons
* Do not require sudo: yes for local and remote persistence pathes
* Fix documentation for correct variable name
* Use a hidden assets directory per default
* Allow configuration of timeout= argument to get_url module
* Add wrapper to ensure persistency paradigm for down- and uploads
* s/sudo/become/g
* Ensure uploaded assets are usable for all users
* Allow autodetection of init system
* Cleanup OS specific vars
* Assert on valid/supported init system
* Re-read local facts only on facts update
* Fix upload directory access mode
* Reduce redundancy in OS data

# 0.3.0

Mark Kusch (1):

* Revert to version 0.1.0
  https://groups.google.com/forum/#!topic/ansible-devel/JlHq-SohYWo

# 0.2.0

Mark Kusch (2):

* Use new Ansible become subsystem
* Update documentation for the become subsystem

# 0.1.0

Mark Kusch (4):

* Remove empty handlers file from repository
* Allow installation of custom packages
* Do not install EPEL configuration if it should not get installed
* Smart configuration for local_action tasks

# 0.0.1

* Initial commit


<!-- vim: set nofen ts=4 sw=4 et: -->
