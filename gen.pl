#!/usr/bin/perl

use strict;
use warnings;
use feature 'signatures';
no warnings 'experimental::signatures';
use File::Basename;

sub uniq (@data) {
    my %seen;
    return grep { !$seen{$_}++ } @data;
}

sub convert ($fileCss, $moduleName) {

    # = collect all class names
    $fileCss = "css/$fileCss.css";

    my $fileTmp = "$fileCss.tmp";
    my $file;

    my @allClassNames;

    open (fileF, '<', $fileCss) or die $!;

    while (my $line=<fileF>) {
        my @classNames = $line =~ /\.([a-z][-a-z0-9]*)/g;
        push(@allClassNames, @classNames);
    }
    my @classNames = uniq (sort @allClassNames);

    # = write purescript code

    # == calculate file name
    my $rootPurs = "src/";

    my $modulePurs = $moduleName;
    $modulePurs =~ s|\.|/|g;
    my $filePurs = "$rootPurs$modulePurs.purs";

    # == prepare directory 
    mkdir dirname($modulePurs);

    # == write purs file
    open(filePursF, '>', $filePurs) or die $!;

    my $header = qq{
        module $moduleName where

        import Halogen.HTML.Core (ClassName(..))

        };

    $header =~ s/^ {8}//mg;
    $header =~ s/^\s+//;
    
    print filePursF $header;

    for my $className (@classNames) {
        chomp $className;
        my $classNameCamel = ($className =~ s/[_-]([a-z0-9])/\u$1/gr);
        print filePursF "$classNameCamel :: ClassName\n";
        print filePursF "$classNameCamel = ClassName \"$className\"\n\n";
    }
}

my $bootstrap = "Halogen.Bootstrap5";

convert ("bootstrap.min", "$bootstrap.Bootstrap");
convert ("bootstrap-icons", "$bootstrap.Icons");