#!/usr/bin/perl

use warnings;
use strict;

my @pcargs;
BEGIN
{
   my $rc = 't/perlcriticrc';
   @pcargs = -f $rc ? (-profile => $rc) : ();
}
use Test::Perl::Critic (-severity => 3, @pcargs);
all_critic_ok();
