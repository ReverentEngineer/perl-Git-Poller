## perl-Git-Poller

Polls git repositories and performs actions on the repository.

# Requirements

This script depends on YAML, Git, Env, IPC::CMD.

For CentOS systems, these can be installed by:
```
yum install perl-YAML perl-Mail-DKIM perl-Env perl-IPC-Cmd
```

# Usage

Example usage:

```
git_poll ./config.yml
```

# Configuration

The configuration file uses YAML. It is an array of the following map-like structure:

* **url** - The URL of a git repository
* **watch** - A regex of the refs to watch for changes.
* **run** - An array of commands to run on a change.

An example of the configuration file:
```
- url: https://github.com/ReverentEngineer/perl-Git-Poller.git
  watch: refs/heads/master
  run:
    - perl Makefile.PL
    - make test
- url: https://github.com/ReverentEngineer/perl-Git-Poller.git
  watch: refs/tags/*
  run:
    - perl Makefile.PL
    - make dist
```
