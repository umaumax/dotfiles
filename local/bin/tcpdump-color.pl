#!/usr/bin/perl
use strict;
use warnings;

my $RED     = "\033[1;31m";
my $GREEN   = "\033[1;32m";
my $YELLOW  = "\033[1;33m";
my $BLUE    = "\033[1;34m";
my $MAGENTA = "\033[1;35m";
my $CYAN    = "\033[1;36m";
my $WHITE   = "\033[1;37m";
my $GRAY    = "\033[0;90m";

my $LIGHT_RED     = "\033[0;91m";
my $LIGHT_GREEN   = "\033[0;92m";
my $LIGHT_YELLOW  = "\033[0;93m";
my $LIGHT_BLUE    = "\033[0;94m";
my $LIGHT_MAGENTA = "\033[0;95m";
my $LIGHT_CYAN    = "\033[0;96m";
my $LIGHT_WHITE   = "\033[0;97m";

my $RESET = "\033[0m";

my $max_length = $ENV{'MAX_LENGTH'} // 210;

while (<STDIN>) {
    s/: Flags.*length [0-9]+//;
    if ( length($_) > $max_length ) {
        $_ = substr( $_, 0, $max_length ) . "$GRAY...$RESET";
    }
    s/^([0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{6})/$MAGENTA$1$RESET/;
    s/^([a-zA-z0-9-]*):(.*)/$GREEN$1$RESET:$BLUE$2$RESET/;
    s/(In  IP [\w.-]* > [\w.-]*)/$LIGHT_RED$1$RESET/;
    s/(Out IP [\w.-]* > [\w.-]*)/$YELLOW$1$RESET/;
    s/(: HTTP.*)/$LIGHT_CYAN$1$RESET/;
    s/^({.*})/$RED$1$RESET/;
    s/(.*\.\.\..*)/$GRAY$1$RESET/;
    print;
}
