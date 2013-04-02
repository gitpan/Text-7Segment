#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Text::7Segment' ) || print "Bail out!
";
}

diag( "Testing Text::7Segment $Text::7Segment::VERSION, Perl $], $^X" );
