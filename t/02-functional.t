#!perl -T

use strict;
use warnings;

use Test::More tests => 10;

use_ok("File::RoundRobin");

{ # create a new file
    
    my $rrfile = File::RoundRobin->new(path => '/tmp/test.txt',size => '1k');
    
    isa_ok($rrfile,'File::RoundRobin');
    
    
}