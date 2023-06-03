#!/usr/bin/perl

my ($file) = @ARGV;

open FILE, $file or die "Could not open $file";

while (my $line=<FILE>) {
    my $camelCase = ($line =~ s/[_-]([a-z0-9])/\u$1/gr);
    my $camelCase1 = substr $camelCase, 0, -1;
    my $line1 = substr $line, 0, -1;
    print "$camelCase1 :: ClassName\n";
    print "$camelCase1 = ClassName \"$line1\"\n\n";
}