#!perl

use strict;
use warnings;

BEGIN {
    use FindBin;
    use lib "$FindBin::Bin/lib";
    
    chdir 't' if -d 't';
    use lib qw[../lib inc];

    require 'local_request.pl';
}

use HTTP::Request;
use Data::Dumper;


my %RpcArgs     = ( 1 => "b" );
#my %RpcRv       = ( auto => 1, begin => 1, end => 1, input => \%RpcArgs );
my %RpcRv       = ( auto => 1, begin => 1, end => 1 );
my $EntryPoint  = 'http://localhost/rpc';
my $Prefix      = 'rpc.functions.';
my %Methods     = (
    # method name       # rv
    'echo.regex'        => 'echo_regex',
    'echo_plain'        => 'echo_plain', 
    'echo.path'         => 'echo_path',

    'echo.path.stash'   => { %RpcRv, function => 'echo_path_stash' },
    'echo.regex.stash'  => { %RpcRv, function => 'echo_regex_stash' },
    'echo_plain_stash'  => { %RpcRv, function => 'echo_plain_stash' },
);



while ( my($meth,$rv) = each %Methods ) {

    use JSON::RPC::Common::Marshal::Text;
    use JSON;
    my $m = JSON::RPC::Common::Marshal::Text->new;
    my $call = {version=>'1.1', method=>$Prefix . $meth, params=>\%RpcArgs, id=>1};
    my $str = JSON::to_json($m->json_to_call(JSON::to_json($call))->deflate());
    print $str;
}

