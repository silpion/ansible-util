# ansible-util

Description...

## Requirements

Requirements...

## Role Variables

* ``variable_name``: Variable description (<!variable type>, default: ``variable default value``)

### complex_variable_name

Complex variable documentation...

### another_complex_variable_name

Complex variable documentation...

## Dependencies

Dependencies...

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

<!Author Name> @<!email_prefix> <!email_suffix>


<!-- vim: set nofen ts=4 sw=4 et: -->
