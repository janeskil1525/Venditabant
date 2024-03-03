use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::Pgroutes',
  VERSION_FROM => 'lib/Mojolicious/Plugin/Pgroutes.pm',
  AUTHOR       => 'A Good Programmer <nospam@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '9.35'},
  test         => {TESTS => 't/*.t'}
);
