use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Invoice',
  VERSION_FROM => 'lib/Invoice.pm',
  AUTHOR       => 'janskil1525@gmail.com',
  PREREQ_PM    => {'Mojolicious' => '9.22'},
  test         => {TESTS => 't/*.t'}
);
