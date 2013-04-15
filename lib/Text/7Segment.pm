package Text::7Segment;

use warnings;
use strict;

use version; our $VERSION = qv('v0.0.1_1');

#TODO: conditionally use Autoloader if needed 
#todo: for autoloadding in windoze (needed for strawberry?)

use Carp qw/carp/;

{
	# Following diagram shows the array index for each segment   
	#  0_     
	# 1|_|3 element #2 in $segments{x} aref is the middle horizontal segment
	# 4|_|6  
	#   5
	# the dot(.) represents an off segment, other characters represent an on segment
	# dot is replaced by space just before displaying
    # dot was chosen over space to keep things simple 
	my %segments = (
		0 => [qw(    _    
			   | . | 
			   | _ |
		      )],
		1 => [qw(    . 
			   . . | 
			   . . | 
		      )],
		2 => [qw(    _ 
			   . _ | 
			   | _ . 
		      )],
		3 => [qw(    _ 
			   . _ | 
			   . _ | 
		      )],
		4 => [qw(    . 
			   | _ | 
			   . . | 
		      )],
		5 => [qw(    _ 
			   | _ . 
			   . _ | 
		      )],
		6 => [qw(    _ 
			   | _ . 
			   | _ | 
		      )],
		7 => [qw(    _ 
			   . . | 
			   . . | 
		      )],
		8 => [qw(    _ 
			   | _ | 
			   | _ | 
		      )],
		9 => [qw(    _ 
			   | _ | 
			   . . | 
		      )],
          # colon
	      ':' => [qw(    . 
			   . o . 
			   . o . 
		      )],
          # space
	      ' ' => [qw(    . 
			   . . . 
			   . . . 
		      )],            
          # underscore
	      _ => [qw(    . 
			   . . . 
			   . . . 
		      )],            
		A => [qw(    _ 
			   | _ | 
			   | . | 
		      )],
		a => [qw(    _ 
			   . _ | 
			   | _ | 
		      )],
		B => [qw(    _ 
			   | _ \) 
			   | _ \) 
		      )],
		b => [qw(    . 
			   | _ . 
			   | _ | 
		      )],
		C => [qw(    _ 
			   | . . 
			   | _ . 
		      )],
		c => [qw(    . 
			   . _ . 
			   | _ . 
		      )],
		D => [qw(    _ 
			   | . \ 
			   | _ / 
		      )],
		d => [qw(    . 
			   . _ | 
			   | _ | 
		      )],
		E => [qw(    _ 
			   | _ . 
			   | _ . 
		      )],
		e => [qw(    _ 
			   | _ | 
			   | _ . 
		      )],
		F => [qw(    _ 
			   | _ . 
			   | . . 
		      )],
		f => [qw(    o 
			   | _ . 
			   | . . 
		      )],
	);
	my %defaults = (
		segments => \%segments,
		string => '0123456789abcdefABCDEF',
		fancy_segments => 0, # 1 - allow chars other than _, |, o
        text_color => 'red',
	);

	sub new {
		my $class = shift;
		my (%params) = @_;
		my $self = {};
		#$self->segments = \%segments;
		foreach my $param (keys %defaults) {
			$self->{$param} = $params{$param} ? $params{$param} : $defaults{$param};
		}

		return bless($self, $class);
	}
}

sub lookup {
	my $self = shift;
	my ($chr) = shift;

	if (! $self->fancy_segments) {
		$chr = lc $chr if ($chr =~ /[BD]/);
		$chr = uc $chr if ($chr =~ /[acef]/);
	}

	if (my $val = $self->segments->{$chr}) {
        map { s!\.! ! } @$val;
		return $val;
	} else {
		warn "Warning: Code not defined for $chr\n";
		return [];
	}
}

# every 7 segments character takes the space of 3 letters and 3 lines
sub disp_str {
	my $self = shift;
	my ($str) = @_;
	$str = ($str) ? $str : $self->{string};
	my @str = split(//, $str);

    my @lookup;
	foreach my $chr (@str) {

        # lookup the 7 seg code for chr
        push @lookup, $self->lookup($chr);

	}

    # the segment 0
    map { print " $_->[0] " } @lookup;
    print "\n";

    # the segments 1..3
    map { print @{$_}[1..3] } @lookup;
    print "\n";

    # the segments 4..6
    map { print @{$_}[4..6] } @lookup;
    print "\n";
}

sub AUTOLOAD {
	my ($self) = shift;

	my $sub = $Text::7Segment::AUTOLOAD;
	(my $prop = $sub) =~ s/.*:://;

	my $val = shift;
	if(defined $val and $val ne '') {
		$self->{$prop} = $val;
	}
	return $self->{$prop};
}

1;

=head1 NAME

Text::7Segment - Display characters in seven-segment style in a text terminal.

*IMPORTANT:* The previous version - 0.0.1 - displayed the text using the Curses module. From this version, the module displays text in a plain terminal without Curses. Curses functionality is being shifted to Curses::7Segment which is coming soon. Please use the previous version if you need the ability to display more characters in a previous line.

=head1 VERSION

This documentation refers to Text::7Segment version 0.0.1_1. This is alpha version, interface may change slightly.

=head1 SYNOPSIS

	use Text::7Segment;

	my $seg7 = Text::7Segment->new();
	$seg7->disp_str(':0123456789 abcdef ABCDEJ');

	# all hex digits available in both upper and lower case
	$seg7->fancy_segments(1); 
	$seg7->disp_str(':0123456789 abcdef ABCDEF');


=head1 DESCRIPTION

This module will display hexadecimal strings and a few other characters in 7 segment style in a terminal. This is the common display style used in lcd calculators, digital watches etc. 

The 7-segment display is usually constrained by hardware, as in, the hardware has seven short segments laid out like the figure eight and subsets of the 7 segments can be turned on or off at a time to display various characters, for example, by applying appropriate voltages to hardware pins or by writing bits into a memory location.

This implementation is intended to be run in a terminal which of course supports a much richer character set and the constraints are purely logical.  It is just an emulation of the 7 segment style display just for fun. 

An advantage of this display style is that a character is readable from a distance due to the large size. An application could use it as a simple large font for displaying numeric data in a terminal window - e.g hw probe state (cpu-temperature, fan speed etc).  

=head1 METHODS

=over 

=item *

new(): the class constructor.  Returns a Text::7Segment object which is an instance of a 7-segment display in a text terminal. 

default: same as the defaults in get/set methods below

Any get or set method name can be passed as a key/value pair to new() to override the corresponding default

	my $s = Text::7Segment->new(string => 'AaBbCc', fancy_segments => 1);

The following methods can be called on the object:

=item *

disp_str($str): display string $str in 7 segment style.

default: see the default in string() below 

Depends on: fancy_segments

Each character in output spans three text lines and three text columns, i.e a 3 x 3 grid on the text terminal. e.g The digit 8 in input  will 
result in the following output:
 _   
|_| 
|_|

=item *

get/set methods:  The get/set methods below can be thought of as attributes in the object. When called with an argument they set the value of the attribute in the object. Without an argument they return the current value of the attribute. The following get/set methods are available:

=over

=item *

string: get or set the hex string to be displayed.

Default: 01234567890abcdefABCDEF

Legal characters in the string are the hex digits (0..f), colon(:), underscore(_) and space( ). Also see the description of fancy_segments method below.

=item *

fancy_segments: get or set the fancy_segments flag

Default: 0 (off)

Normally, the 7 segment display can show the digits b and d in lowercase only because the uppercase B and D cannot be distinguished from 8 and 0 respectively. This is an inherent limitation of the 7 segment style. However, since we are just emulating the 7-segment display, we are able to cheat by using extra characters. 

When fancy_segments is not set, this module uses only the following characters: underscore(_), pipe(|) to diplay hex digits. Uppercase B and D in string are silently displayed in lowercase. 

When set to a true value, the slash(/) and closing-parens(\)) characters are also used so all the alphanumeric digits (a..f) can be displayed in both upper and lower case.

=item * TODO: allow user to override any of the 7 segments or supply the whole %segments hash

=back

=back

=head1 DIAGNOSTICS

If the string contains a character outside of the character class [a..fA..F0..9: ], it will not be displayed and a warning will be given. It will be a good idea to redirect the error output to somewhere other than the terminal if this is likely.

	Warning: Code not defined for $chr

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

None: this is a pure perl implementation that uses only the core modules.

=head1 BUGS AND LIMITATIONS

No known bug. Please report problems to manigrew (Manish.Grewal@gmail.com). Patches are welcome.

The string to be displayed has to be specified a line at a time. This is because a character spans 3 lines and it is not possible to go back to a previous line in a terminal to show more characters. If you have a requirement to display more characters in a line later, see the module Curses::7Segment on CPAN.

=head1 ROADMAP

Following is a quick and dirty list of future enhancements:

- support different size of character - not just 3x3, e.g like bsd banner command
- allow lookup func override if not already available and also good to have an example of how it should be subclassed.
- use standard conventional letters for segments (a..g) in var names/comments
- use colors 

=head1 SEE ALSO

=over

=item * Curses::7Segment - Coming soon

=item * http://en.wikipedia.org/wiki/Seven-segment_display 

=back

=head1 AUTHOR

manigrew (Manish.Grewal@gmail.com)

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2013 manigre (Manish.Grewal@gmail.com). All rights reserved.

This module is free software; you can redistribute it and/or modify it 
under the same terms as Perl itself. See L<perlartistic>.

=cut
