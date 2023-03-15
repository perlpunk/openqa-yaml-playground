#!/usr/bin/perl -w
use strict;
use testapi;
use autotest;
use needle;
use File::Find;

my $distri = testapi::get_var("CASEDIR") . '/lib/susedistribution.pm';
require $distri;
testapi::set_distribution(susedistribution->new());

$testapi::password //= get_var("PASSWORD");
$testapi::password //= 'nots3cr3t';

sub loadtest($) {
    my ($test) = @_;
    autotest::loadtest("/tests/$test");
}

loadtest "install/boot.pm";
loadtest "yaml/playground.pm";

loadtest "shutdown/shutdown.pm";

1;
