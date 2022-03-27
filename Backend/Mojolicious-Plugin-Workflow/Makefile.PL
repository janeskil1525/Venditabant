use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::Workflow',
  VERSION_FROM => 'lib/Mojolicious/Plugin/Workflow.pm',
  AUTHOR       => 'Jan Eskilsson <janeskil1525@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '9.22'},
  test         => {TESTS => 't/*.t'}
);
