use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Salesorder',
  VERSION_FROM => 'lib/Salesorder.pm',
  AUTHOR       => 'janskil1525@gmail.com',
  PREREQ_PM    => {'Mojolicious' => '9.22'},
  test         => {TESTS => 't/*.t'}
);
