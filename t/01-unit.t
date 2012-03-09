#!perl -T

use strict;
use warnings;

use Test::More tests => 10;

use_ok("File::RoundRobin");

{ #convert_size
    
    is(File::RoundRobin::convert_size('1000'),1000,'Simple number');
    is(File::RoundRobin::convert_size('10K'),10_000,'Kb test1');
    is(File::RoundRobin::convert_size('1.3Kb'),1_300,'Kb test2');
    is(File::RoundRobin::convert_size('10M'),10_000_000,'Mb test');
    is(File::RoundRobin::convert_size('12Gb'),12_000_000_000,'Gb test');
    
    eval {
        File::RoundRobin::convert_size('asdf');
    };
    like($@,qr/^Broke size format. See pod for accepted formats/,'Fails for broken size');
    
}


{ #open new file
    
    my ($fh,$size,$start_point) = File::RoundRobin::open_file(
                                                path => "test.txt",
                                                mode => 'new',
                                                size => '1000'
                                    );
    
    ok(defined $fh,"File handle created");
    is($size,1000,"Size ok");
    is($start_point,10,"Start point ok");
    
    close($fh);
    
    open($fh,"<",'test.txt');
    
    local $/ = undef;
    
    my $data = <$fh>;
    
    is($data,"100000\00010\000",'File content correct');
    
    unlink("text.txt");
           
}

{ #open new file
    
    my ($fh,$size,$start_point) = File::RoundRobin::open_file(
                                                path => "test.txt",
                                                mode => 'new',
                                                size => '1000'
                                    );
    
    ok(defined $fh,"File handle created");
    is($size,1000,"Size ok");
    is($start_point,10,"Start point ok");
    
    unlink("text.txt");
           
}