#!/usr/bin/perl -Tw
#=cut
#= Kid Radd: KREPES: Screen
# Project   : Kid Radd: KREPES: Screen
# File      : <KREPES root>/src/RaddTeam/KREPES/Screen.pm
# Group     : NIMH Labs, Radd Team
# Authors   : Katrina "the Lamia" Payne AKA FullMetalHarlot
# Copyright : <KREPES root>/Documentation/COPYRIGHT.txt
# Licenses  : <KREPES root>/Documentation/LICENSES.txt
#== Purpose
# This is mostly a typing system for within Kid Radd KREPES.
package RaddTeam::KREPES::Screen;

# Versioning.
our $VERSION = v0.0.1;

use MooseX::POE;
use SDL;
use SDL::App;

#= Attributes

has Screen_Title => (
	is => q[rw],
	isa => q[Str],
	lazy => 1,
	required => 1,
);

has Screen_Icon => (
	is => q[rw],
	isa => q[KR::Canvas],
	lazy => 1,
	required => 1,
);

has qw[width height offset_x offset_y] => (
	is => q[r],
	isa => q[Int],
	lazy => 1,
	required => 1,
);

has write_buffer => (
	is => q[rw],
	isa => q[KR::Canvas],
	lazy => 1,
	required => 1,
);

has hold_buffer => (
	is => q[r],
	isa => q[KR::Canvas],
	builder => q[_build_hold_buffer],
	writer => q[_write_hold],
	required => 1,
);

has levels => (
	is => q[rw],
	isa => q[LevelList],
	lazy => 1,
	required => 1,
);

#=Methods

#=Events

event init_window => sub {
    # fill this in
};

event update_title => sub {

};

event draw => sub {

};

no MooseX::POE;
__PACKAGE__->meta->make_immutable();
POE::Kernel->run();
1;

__END__;

=pod