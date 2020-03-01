use strict;
use Test;
use Git::Poller::Cache;
use Env qw(HOME);

BEGIN { plan tests => 3 }

my $cache = Cache->new("./test_cache");
ok(not defined $cache->lookup("repo", "ref"));
$cache->store("repo", "ref", "b426150241c0228d602aeef5fb44e677996aec51");
ok($cache->lookup("repo", "ref"), "b426150241c0228d602aeef5fb44e677996aec51");
$cache->store("repo", "ref", "b426150241c0228d602aeef5fb44e677996aec50");
ok($cache->lookup("repo", "ref"), "b426150241c0228d602aeef5fb44e677996aec50");
