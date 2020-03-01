use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Git::Poller',
    AUTHOR       => q{Jeff Caffrey-Hill <jeff@reverentengineer.com>},
    VERSION_FROM => 'lib/Git/Poller.pm',
    ABSTRACT     => 'Polling Git repositories and peroming changes',
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002
        ? ( 'LICENSE' => 'perl' )
        : () ),
    PL_FILES  => {},
    EXE_FILES => ['bin/git_poll'],
    PREREQ_PM => {
        'Git'      => 0.01,
        'IPC::Cmd' => 1.02,
        'YAML'     => 1.24,
        'Env'      => 1.04,
    },
    TEST_REQUIRES => {
          'Test'    => 1.001014,
    },
);

tests => { TESTS => 't/*.t' };
