package File::RoundRobin;

use 5.006;
use strict;
use warnings;

=head1 NAME

File::RoundRobin - Round Robin text files

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This module implements a Round-Robin text file.

The text file will not grow beyond the size we specify.

The benefit of using this module is that you can log a certain amount of
information without having to care about filling your hard drive or setting up a
log-rotate mechanism.

Example :

    use File::RoundRobin;

    my $foo = File::RoundRobin->new(
                                    path => '/tmp/sample.txt',
                                    size => '100M',
                                    mode => 'new'
                                );
    or
    
    my $foo = File::RoundRobin->new(path => '/tmp/sample.txt', mode => 'append');

=head1 SUBROUTINES/METHODS

=head2 new

Returns a new filehandle 

=cut

sub new {
    my $class = shift;
    
    my %params = (
                mode => 'new',
                @_
    );
    
    $params{size} = convert_size($params{size});
    
    die "You must specify the file size" if ($params{mode} eq "new" && ! defined $params{size});
    
    my ($fh,$size,$start_point) = open_file(%params);
    
    my $self = {
                _fh_ => $fh,
                _size_ => $size,
                _start_point_ => $start_point,
    };
    
    bless $self, $class;
    
    return $self;
}


=head1 Private methods

=head2 convert_size

Converts the size from a human readable form into bytes

Example of acceptable formats :

=over 4

=item * 1000

=item * 120K  or 120Kb

=item * 15M  or 15Mb

=item * 1G  or 1Gb

=back

=cut
sub convert_size {
    my $size = shift;
    
    return undef unless defined $size;
    
    return $size if $size =~ /^\d+$/;
    
    my %sizes = (
                'K' => 10**3,
                'M' => 10**6,
                'G' => 10**9,
                );
    
    if ($size =~ /^(\d+(?:\.\d+)?)(K|M|G)b?$/i ) {
        return $1 * $sizes{uc($2)};
    }
    else {
        die "Broke size format. See pod for accepted formats";
    }

}


=head2 open_file

Has two modes :

=over 4

=item 1. In append mode it opens an existing file

=item 2. In new mode it creates a new file

=back

=cut
sub open_file {
    my %params = @_;
    
    die "You myst specifi the name of the file!" unless $params{path};
    die "Path is a directory!" if -d $params{path};
    
    my ($fh,$size,$start_point);
    if ($params{mode} eq "new") {
        die "You must specify the size of the file!" unless defined $params{size};
        $size = $params{size};
        open($fh,"+>",$params{path}) || die "Cannot open file $params{path}";
        print $fh $params{size} ."\000";
        $start_point = length($params{size}) * 2 + 2;
        print $fh ("0" x (length($params{size}) - length($start_point) )) . $start_point ."\000";
    }
    
    return ($fh,$size,$start_point);
}


DESTROY {
    my $self = shift;
    
    close($self->{_fh_});
}

=head1 AUTHOR

Gligan Calin Horea, C<< <gliganh at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-file-roundrobin at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=File-RoundRobin>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc File::RoundRobin


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=File-RoundRobin>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/File-RoundRobin>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/File-RoundRobin>

=item * Search CPAN

L<http://search.cpan.org/dist/File-RoundRobin/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Gligan Calin Horea.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of File::RoundRobin
