#!/usr/bin/env perl

=head1 NAME

B<t.pl> - Transpose a matrix in given file.

=head1 SYNOPSIS

 USAGE: t.pl -i /path/to/input_matrix_file
        [-o /path/to/output_file
        -sep [default|c|s], default: tab
        -ow
        -log /path/to/log_file
        -help|h]

=head1 OPTIONS

 -i input_file
    Input matrix file. Element can be separated by tab, space or comma.

 -o output_file
    Output file, not required, default to STDOUT.

 -sep
    optional. specify the separator in input file.
    By default, tab is used in input file.
    -sep c for comma, -sep s for space.

 -ow
    Overwrite the output file if it already exists.

 --log,-l
    Log file

 --help,-h
    Display full help message


=head1  DESCRIPTION

This script transpose a matrix in given file, which can be separated by tab(default), space or comma.

The default output is STDOUT, however you can specify -o output_file to change this.

=head1 INPUT

 A matrix file:
 (with tab separator)
 1	2	3
 3	5	6
 (with space separator)
 1 2 3
 3 5 6
 (with comma separator)
 1,2,3
 3,5,6

=head1  OUTPUT

 A transposed matrix(separator will be same as the input_file):
 1     3
 2     5
 3     6

=head1  CONTACT

 Zhu Xitong
 z724@qq.com

=cut

use warnings;
use strict;
use Getopt::Long qw(:config no_ignore_case no_auto_abbrev);
use Pod::Usage;
use Data::Dumper;

##display simple help
if (@ARGV==0){
    pod2usage(-exitval=>0, -verbose=>1);
}

my %options = ();
GetOptions(\%options,
        'i=s',
        'o=s',
        'sep=s',
        'ow',
        'log|l=s',
        'help|h') || pod2usage();

## display full documentation
if( $options{'help'}){
    pod2usage( {-exitval => 0, -verbose => 2, -output => \*STDERR} );
}

## make sure everything passed was peachy
&check_parameters(\%options);

# open the log if requested
my $logfh;
if (defined $options{log}) {
    open($logfh, ">$options{log}") || die "Can't create log file: $!";
}

# open the out if requested
my $outfh;
if (defined $options{o}){
    open $outfh, ">$options{o}" or die "Can't open output file: $!";
    select $outfh;
}


# get separator
my $separator = "\t";
if (defined $options{sep}){
    if ($options{sep} eq 's'){
        $separator = ' ';
    }
    elsif ($options{sep} eq 'c'){
        $separator = ',';
    }
    else{
        die "\n\tError: Unknown separator in -sep! Dfault: tab; -sep s for space; -sep c for comma.\n";
    }
}


## CODE HERE

open IN, $options{i} or die $!;
my @m;
my $r = 0;
my $t;
_log("Start working!......");
while(<IN>) {
        chomp;
        my $c = 0;
        my @line = split/$separator/;
        for my $line (@line){
                $m[$r][$c] = $line;
                $c++;
        }
        $r++;
        $t = $c;
}
_log("Reading input file finished!");

for my $x (0..$t - 1){
  for my $y  (0..$r - 1){
		if ($y != $r - 1){
#                  print $m[$y][$x],"$separator";
                  print $m[$y][$x],"\t";
		}
		else{
			print $m[$y][$x];
		}
  }
  if ($x != $t -1){
    print "\n";
  }
}
_log("Done!");
select STDOUT;

exit(0);


sub _log {
    my $msg = shift;

    print $logfh "$msg\n" if $logfh;
}


sub check_parameters {
    my $options = shift;
#   print Dumper(\$options);

    # make sure required arguments were passed
    my @required = qw( i );
    for my $option ( @required ) {
        if ( !defined $options{$option} ) {
            die "--$option is a required option";
        }
    }
    
    #check input file
    if (! -e $options{i}){
        die "\n\tError! Input file $options{i} doesn't exist, please check!";
    }
    
    #check output file
    if (defined $options{o} && -e $options{o} && !$options{ow}){
        die "\n\tError! Output file $options{o} already exist and overwrite not turn on, please specify another file.";
    }

    
    # handle some defaults
    #$options{optional_argument2}   = 'foo'  unless ($options{optional_argument2});
}
