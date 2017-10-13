#!perl -T

use strict;
use warnings;

use Test::More tests => 5;

use_ok("File::RoundRobin");

{ # create a new file 

    my $rrfile = File::RoundRobin->new(path => '/non-existent-path/test.txt',size => '1k');
    
    is($rrfile,undef,'File failed to create');
    
    is($@, "No such file or directory", "Error correctly reported");
}


{ # create a new file 

    my $temp_fh;
    open($temp_fh, ">", '05_2_test.txt');
    print $temp_fh "This is a simple text file\n";
    close($temp_fh);

    my $rrfile = File::RoundRobin->new(path => '05_2_test.txt',size => '1k', mode => 'append');
    
    is($rrfile,undef,'File failed to open in append mode');
    
    is($@, "File does not look like a File::RoundRobin file - missing headers", "Error correctly reported");
    
    unlink('05_2_test.txt');
}
