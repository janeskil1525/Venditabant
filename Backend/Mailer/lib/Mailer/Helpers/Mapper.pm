package Mailer::Helpers::Mapper;
use Mojo::Base -base, -signatures;

use HTML::Entities;
use Text::Template;

sub map_text($self, $hash, $template) {

    my $template_body = Text::Template->new(TYPE => 'STRING', SOURCE => $template );
    my $result = $template_body->fill_in(HASH => $hash);

    return $result;
}
1;