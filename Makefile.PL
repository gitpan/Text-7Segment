use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Text::7Segment',
    AUTHOR              => q{MANIGREW <Manish.Grewal@gmail.com>},
    VERSION_FROM        => 'lib/Text/7Segment.pm',
    ABSTRACT_FROM       => 'lib/Text/7Segment.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Text-7Segment-*' },
);
