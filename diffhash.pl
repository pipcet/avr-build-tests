#!/usr/bin/perl
use Digest::MD5;
my $seen = "";
while (<>) {
    next if (/^---/);
    next if (/^\+\+\+/);
    if (/^[ -+]/) {
	$seen .= $_;
    }
}
print Digest::MD5::md5_hex($seen) . "\n";
