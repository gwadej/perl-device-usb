use strict;
use warnings;
use Inline::MakeMaker;

WriteMakefile(
    NAME                => 'Device::USB',
    AUTHOR              => 'G. Wade Johnson <wade@anomaly.org>',
    VERSION_FROM        => 'lib/Device/USB.pm',
    ABSTRACT_FROM       => 'lib/Device/USB.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
	'Inline::C' => 0,
	'Carp' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => {
        FILES => 'Device-USB-* USB.inl _Inline'
    },
);
