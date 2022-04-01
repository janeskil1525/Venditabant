use strict;
use warnings;

use ExtUtils::MakeMaker;
use File::ShareDir::Install qw{install_share};

install_share  'share';

WriteMakefile(
    NAME => 'venditabant',
    VERSION   => '0.1.5',
    PREREQ_PM => {'Mojolicious' => '8.55'},
    AUTHOR       => 'Jan Eskilsson <janeskil1525@cpan.org>',
    test      => {TESTS => 't/*.t'},
    EXE_FILES    => [ qw{
        script/venditabant
        script/check.pl
        script/scheduler.pl
    }],
);

package MY;
use File::ShareDir::Install qw(postamble);