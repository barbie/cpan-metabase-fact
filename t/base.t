# Copyright (c) 2008 by Ricardo Signes. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

use strict;
use warnings;

use Test::More;
use Test::Exception;

use lib 't/lib';
use CPAN::Metabase::Fact::TestFact;

plan tests => 15;

require_ok( 'CPAN::Metabase::Fact' );

#--------------------------------------------------------------------------#
# fixtures
#--------------------------------------------------------------------------#    

my ($obj, $err);

#--------------------------------------------------------------------------#
# required parameters missing
#--------------------------------------------------------------------------#

eval { $obj = CPAN::Metabase::Fact->new() };
$err = $@;
like( $err, qr/Mandatory parameters/, "new() without params throws error" );
for my $p ( qw/ resource content / ) {
    like( $err, qr/$p/, "... '$p' noted missing" );
}

is(
  CPAN::Metabase::Fact->default_schema_version,
  1,
  "schema_version() defaults to 1",
);

#--------------------------------------------------------------------------#
# fake an object and test methods
#--------------------------------------------------------------------------#

# type is class munged from "::" to "-"
is( CPAN::Metabase::Fact->type, "CPAN-Metabase-Fact", 
  "->type converts class name" 
);

# unimplemented
for my $m ( qw/content_as_bytes content_from_bytes validate_content/ ) {
    my $obj = bless {} => 'CPAN::Metabase::Fact';
    throws_ok { $obj->$m } qr/$m\(\) not implemented by CPAN::Metabase::Fact/,
      "$m not implemented";
}

#--------------------------------------------------------------------------#
# new should take either hashref or list
#--------------------------------------------------------------------------#

my $string = "Who am I?";

my $args = {
    resource => "JOHNDOE/Foo-Bar-1.23.tar.gz",
    content  => $string,
};

lives_ok{ $obj = CPAN::Metabase::Fact::TestFact->new( $args ) } 
    "new( <hashref> ) doesn't die";

isa_ok( $obj, 'CPAN::Metabase::Fact::TestFact' ); 

lives_ok{ $obj = CPAN::Metabase::Fact::TestFact->new( %$args ) } 
    "new( <list> ) doesn't die";

isa_ok( $obj, 'CPAN::Metabase::Fact::TestFact' );

is( $obj->type, "CPAN-Metabase-Fact-TestFact", "object type is correct" );
is( $obj->content, $string, "object content correct" );
