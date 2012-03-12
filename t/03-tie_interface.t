#!perl

use strict;
use warnings;

use Test::More tests => 11;
use Data::Dumper;

use_ok("File::RoundRobin");

{ # create a new file , write something and read it back
    
    local *FH;
 	tie *FH, 'File::RoundRobin', path => 'test.txt',size => '1k';

    my $fh = *FH;

    print $fh "foo bar";

	close($fh);
	
	tie *FH, 'File::RoundRobin', path => 'test.txt',mode => 'read';
	
	$fh = *FH;
	
	my $char = getc($fh);
	is($char,'f','getc works');
	
	my $buffer;	
	my $bytes = read($fh,$buffer,10);
	
	is($buffer,"oo bar",'read returned text as expected');
	is($bytes,6,'length returned ok');
	
	unlink('test.txt');
}