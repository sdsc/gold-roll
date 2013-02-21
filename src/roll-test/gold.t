#!/usr/bin/perl -w
# gold roll installation test.  Usage:
# gold.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend
 
use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = 'Frontend|Login';
my $goldIsInstalled = -d '/opt/gold';
my $output;

# gold-client.xml
if($appliance =~ /$installedOnAppliancesPattern/) {
  ok($goldIsInstalled, 'gold installed');
} else {
  ok(! $goldIsInstalled, 'gold not installed');
}
SKIP: {
  skip 'gold not installed', 10 if ! $goldIsInstalled;
  ok(-x '/usr/bin/suidperl', 'perl-suidperl installed');
  ok(-d '/usr/include/libxml2/libxml/', 'libxml2-devel installed');
  ok(-f '/opt/gold/lib/perl5/CGI.pm', 'gold perl dependencies installed');
  ok(-f '/opt/gold/etc/auth_key', 'gold auth_key created');
  ok(-f '/opt/gold/etc/gold.conf', 'gold.conf created');
  ok(-f '/opt/gold/etc/goldd.conf', 'goldd.conf created');
  `grep -s '^gold:' /etc/passwd 2>&1`;
  ok($? == 0, 'gold user created');
  $output = `which glsproject`;
  chomp($output);
  ok($output eq "$ENV{GOLDHOMEDIR}/bin/glsproject", 'gold in default path');
  ok(-d '/var/log/gold', '/var/log/gold created');
  $output = `ls -ld /var/log/gold/gold.log 2>&1`;
  like($output, qr/.rw.rw.rw./, '/var/log/gold/gold.log world writable');
}

# gold-server.xml
SKIP: {
  skip 'not server', 4 if $appliance ne 'Frontend';
  ok(-x '/usr/bin/psql', 'postgres installed');
  ok(-f '/etc/init.d/gold', 'goldd service installed');
  SKIP: {
    skip 'pg init running', 1 if -f '/etc/rc.d/rocksconfig.d/post-49-postgres';
    $output = `echo '\\l' | psql -U gold`;
    ok($output =~ /^\s*gold/m, 'gold DB created');
  }
  SKIP: {
    skip 'gold init running', 1 if -f '/etc/rc.d/rocksconfig.d/post-50-gold';
    $output = `ps wwaux | grep goldd | grep -v grep`;
    ok($output =~ /goldd/, 'goldd service running');
  }
}

