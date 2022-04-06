use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Suppliers',
  VERSION_FROM => 'lib/Suppliers.pm',
  AUTHOR       => 'janskil1525@gmail.com',
  PREREQ_PM    => {'Mojolicious' => '9.22'},
  test         => {TESTS => 't/*.t'}
);
