use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'CheckPoints',
  VERSION_FROM => 'lib/CheckPoints.pm',
  AUTHOR       => 'janskil1525@gmail.com',
  PREREQ_PM    => {'Mojolicious' => '9.22'},
  test         => {TESTS => 't/*.t'},
    EXE_FILES    => [ qw{
        script/check.pl
    }],
);
