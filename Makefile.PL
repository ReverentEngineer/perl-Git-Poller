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
    PL_FILES  => {
      'bin/git_poll.PL' => 'bin/git_poll'
    },
    PREREQ_PM => {
        'Git'      => 0.01,
    },
    TEST_REQUIRES => {
          'Test'    => 1.001014,
    },
);
