#!/usr/bin/env perl
use strict;
use warnings;

my $template_path = 'conf/general.yml-example';
my $output_path   = 'conf/general.yml.deployed';

-f $template_path or die "Missing template file: $template_path\n";

open my $in_fh, '<', $template_path or die "Unable to read $template_path: $!\n";
local $/ = undef;
my $content = <$in_fh>;
close $in_fh;

my $FMS_DB_HOST                    = _req('FMS_DB_HOST');
my $FMS_DB_PORT                    = _req('FMS_DB_PORT');
my $FMS_DB_NAME                    = _req('FMS_DB_NAME');
my $FMS_DB_USER                    = _req('FMS_DB_USER');
my $FMS_DB_PASS                    = _req('FMS_DB_PASS');

my $BASE_URL                       = _req('BASE_URL');

my $EMAIL_DOMAIN                   = _req('EMAIL_DOMAIN');
my $CONTACT_EMAIL                  = _req('CONTACT_EMAIL');
my $CONTACT_NAME                   = _req('CONTACT_NAME');
my $DO_NOT_REPLY_EMAIL            = _req('DO_NOT_REPLY_EMAIL');

my $STAGING_SITE                   = _req('STAGING_SITE');
my $STAGING_FLAGS_SEND_REPORTS    = _req('STAGING_FLAGS_SEND_REPORTS');
my $STAGING_FLAGS_SKIP_CHECKS     = _req('STAGING_FLAGS_SKIP_CHECKS');
my $STAGING_FLAGS_HIDE_STAGING_BANNER = _req('STAGING_FLAGS_HIDE_STAGING_BANNER');

my $MAPIT_URL                      = _req('MAPIT_URL');
my $MAPIT_TYPES                    = _req('MAPIT_TYPES');

my $SMTP_SMARTHOST                 = _req('SMTP_SMARTHOST');
my $SMTP_TYPE                     = _req('SMTP_TYPE');
my $SMTP_PORT                     = _req('SMTP_PORT');
my $SMTP_USERNAME                 = _req('SMTP_USERNAME');
my $SMTP_PASSWORD                 = _req('SMTP_PASSWORD');

my $MEMCACHED_HOST                = _req('MEMCACHED_HOST');
my $CACHE_TIMEOUT                 = _req('CACHE_TIMEOUT');
my $QUEUE_DAEMON_PROCESSES        = _req('QUEUE_DAEMON_PROCESSES');

my $ALLOWED_COBRANDS              = _req('ALLOWED_COBRANDS');

#
# Scalar replacements.
#
$content =~ s/^FMS_DB_HOST:\s*'.*'$/FMS_DB_HOST: '$FMS_DB_HOST'/m;
$content =~ s/^FMS_DB_PORT:\s*'.*'$/FMS_DB_PORT: '$FMS_DB_PORT'/m;
$content =~ s/^FMS_DB_NAME:\s*'.*'$/FMS_DB_NAME: '$FMS_DB_NAME'/m;
$content =~ s/^FMS_DB_USER:\s*'.*'$/FMS_DB_USER: '$FMS_DB_USER'/m;
$content =~ s/^FMS_DB_PASS:\s*'.*'$/FMS_DB_PASS: '$FMS_DB_PASS'/m;

$content =~ s/^BASE_URL:\s*'.*'$/BASE_URL: '$BASE_URL'/m;

$content =~ s/^EMAIL_DOMAIN:\s*'.*'$/EMAIL_DOMAIN: '$EMAIL_DOMAIN'/m;
$content =~ s/^CONTACT_EMAIL:\s*'.*'$/CONTACT_EMAIL: '$CONTACT_EMAIL'/m;
$content =~ s/^CONTACT_NAME:\s*'.*'$/CONTACT_NAME: '$CONTACT_NAME'/m;
$content =~ s/^DO_NOT_REPLY_EMAIL:\s*'.*'$/DO_NOT_REPLY_EMAIL: '$DO_NOT_REPLY_EMAIL'/m;

$content =~ s/^STAGING_SITE:\s*\d+/STAGING_SITE: $STAGING_SITE/m;

$content =~ s/^(\s*send_reports:\s*).*$/${1}$STAGING_FLAGS_SEND_REPORTS/m;
$content =~ s/^(\s*skip_checks:\s*).*$/${1}$STAGING_FLAGS_SKIP_CHECKS/m;
$content =~ s/^(\s*hide_staging_banner:\s*).*$/${1}$STAGING_FLAGS_HIDE_STAGING_BANNER/m;

$content =~ s/^MAPIT_URL:\s*'.*'$/MAPIT_URL: '$MAPIT_URL'/m;
$content =~ s/^MAPIT_TYPES:\s*.*/MAPIT_TYPES: $MAPIT_TYPES/m;

$content =~ s/^SMTP_SMARTHOST:\s*'.*'$/SMTP_SMARTHOST: '$SMTP_SMARTHOST'/m;
$content =~ s/^SMTP_TYPE:\s*'.*'$/SMTP_TYPE: '$SMTP_TYPE'/m;
$content =~ s/^SMTP_PORT:\s*'.*'$/SMTP_PORT: '$SMTP_PORT'/m;
$content =~ s/^SMTP_USERNAME:\s*'.*'$/SMTP_USERNAME: '$SMTP_USERNAME'/m;
$content =~ s/^SMTP_PASSWORD:\s*'.*'$/SMTP_PASSWORD: '$SMTP_PASSWORD'/m;

$content =~ s/^MEMCACHED_HOST:\s*'.*'$/MEMCACHED_HOST: '$MEMCACHED_HOST'/m;
$content =~ s/^CACHE_TIMEOUT:\s*.*/CACHE_TIMEOUT: $CACHE_TIMEOUT/m;
$content =~ s/^QUEUE_DAEMON_PROCESSES:\s*.*/QUEUE_DAEMON_PROCESSES: $QUEUE_DAEMON_PROCESSES/m;

#
# ALLOWED_COBRANDS is a short multi-line YAML block in general.yml-example.
# Replace the whole block with a single inline YAML list fragment.
#
$content =~ s/^ALLOWED_COBRANDS:\n(?:^[ \t]+.*\n)+\n/ALLOWED_COBRANDS: $ALLOWED_COBRANDS\n\n/m;

open my $out_fh, '>', $output_path or die "Unable to write $output_path: $!\n";
print {$out_fh} $content;
close $out_fh;

print "Rendered $output_path from $template_path\n";

sub _req {
    my ($var) = @_;
    if (!defined $ENV{$var}) {
        die "Missing required environment variable: $var (required for rendering general.yml.deployed)\n";
    }
    return $ENV{$var};
}

