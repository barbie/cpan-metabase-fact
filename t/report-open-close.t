# Copyright (c) 2008 by Ricardo Signes. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

use strict;
use warnings;

use Test::More;
use Test::Exception;

plan tests => 14;

require_ok( 'CPAN::Metabase::Report' );
require_ok( 'CPAN::Metabase::Fact::TestFact' );

#--------------------------------------------------------------------------#
# fixtures
#--------------------------------------------------------------------------#    

require t::lib::ReportSubclasses;
require t::lib::FactSubclasses;

my %params = (
    resource => "JOHNDOE/Foo-Bar-1.23.tar.gz",
);

my %facts = (
    FactOne     => FactOne->new( %params, content => "FactOne" ),
    FactTwo     => FactTwo->new( %params, content => "FactTwo" ),
);

my ($obj, $err);

#--------------------------------------------------------------------------#
# report that takes 1 fact
#--------------------------------------------------------------------------#

lives_ok { 
  $obj = JustOneFact->open( %params, content => [ $facts{FactOne} ] );
} "lives: open() given 1 fact";

isa_ok( $obj, 'JustOneFact' );

lives_ok {
  $obj->close;
} "lives: close()";

lives_ok { 
  $obj = JustOneFact->open( %params )
} "lives: open() given no facts";

isa_ok( $obj, 'JustOneFact' );

lives_ok {
  $obj->add( 'FactOne' => 'This is FactOne' );
} "lives: add( 'Class' => 'foo' )";

lives_ok {
    $obj->close;
} "lives: close()";

#--------------------------------------------------------------------------#
# errors
#--------------------------------------------------------------------------#

lives_ok { 
  $obj = JustOneFact->open( %params )
} "lives: open() given no facts";

isa_ok( $obj, 'JustOneFact' );

lives_ok {
  $obj->add( 'FactOne' => 'This is FactOne' );
} "lives: add( 'Class' => 'foo' )";

lives_ok {
  $obj->add( 'FactTwo' => 'This is FactTwo' );
} "lives: add( 'Class2' => 'foo' )";

throws_ok {
    $obj->close;
} qr/content invalid/, "dies: close() with two facts";


