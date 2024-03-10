package Database::Helper::Instring;
use Mojo::Base  -base, -signatures;



sub build_in_string($self, $list) {

    my $result = "";
    my $length = scalar @{ $list };
    for (my $i = 0; $i < $length; $i++) {
        my $field = @{ $list }[$i]->{table_name};
        if ($i == $length - 1) {
            $result .= "'" . $field . "'";
        } else {
            $result .= "'" . $field  . "'" . ", ";
        }
    }

    $result = 'mojo_migrations' unless $result;
    return $result;
}
1;