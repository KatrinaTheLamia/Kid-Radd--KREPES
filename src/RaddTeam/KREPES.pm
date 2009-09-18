#!/usr/bin/perl -Tw
#=cut
#= Kid Radd: KREPES: KREPES.pm
# Project   : Kid Radd: KREPES
# File      : <KREPES root>/src/RaddTeam/KREPES.pm
# Group     : NIMH Labs, Radd Team
# Authors   : Katrina "the Lamia" Payne AKA FullMetalHarlot
# Copyright : <KREPES root>/Documentation/COPYRIGHT.txt
# Licenses  : <KREPES root>/Documentation/LICENSES.txt
#== Purpose
# This file is intended to setup a method for people to load and talk to 
# Kid Radd: KREPES' various files.

#= Code
#== Setup
# Package is part of RaddTeam, and more specifically KREPES. Does this mean
# there will be other RaddTeam packages? Yes, yes it does. This also means 
# when this is propperly installed, that it will be loaded into a library 
# directory of RaddTeam, with this file named KREPES.pl.
package RaddTeam::KREPES;

#=== Important Variables

our $VERSION = v0.0.1;

#=== Loading libraries
# First I generally load the system libraries first. Most of these are pretty 
# standard stuff to include for this sort of project.

# First some basic MooseX stuff.
use MooseX::POE;
use MooseX::StrictConstructor;
use MooseX::Params::Validate;

use SDL;

#=== Theory here
# These generally will use a MVC setup for how they are done. Well, except the 
# network code, as that itself will deal with MVC setups inside itself. There 
# is just one slight difference. While in these docs, they will be labelled 
# as being Model/View/Controller, in the actual code, they will be labelled on
# what do they do. That way you can extend a RaddTeam::KREPES::Screen and 
# know via ISA, that it will likely end up doing something involving 
# display stuff.

#=== Types
# Well, looks like we'll be messing with the idea of using KREPES types within 
# KREPES. This is mostly to make the code look prettier.

use RaddTeam::KREPES::Types

#=== Attributes
# Well, here we go, various attributes

#==== Flavour
# I _thought_ this was funny.

has q[Flavour] => (
	documentation => q[I blame sleep deprivation and lolcats],
	is => q[r],
	isa => q[Str],
	default => "tasty code", # Yes, we does has a flavour!
);

#==== Views
# Pretty much output attributes. These will be stuff that when talked to,
# will output to various places.

has q[Logger] => (
	documentation => q[This is where logging is sent to],
	is => q[rw],
	isa => q[KR_Logger]',
	builder => q[_build_logger],
	init_arg => q[log],
	required => 1,
);

has q[Screen] => (
	is => q[rw],
	isa => q[KR_Screen],
	init_arg => q[screen],
	lazy_build => 1,
);

has q[Speakers] => (
	is => q[rw],
	isa => q[KR_Speakers],
	init_arg => q[speakers],
	lazy_buold => 1,
);

#==== Controllers
# Mostly input functions of various kinds.

has q[Config] => (
	documentation => q[This is where the configuration object is stored],
	is => q[rw],
	isa => q[KR_Config],
	lazy_build => 1,
	init_arg => q[config],
);

has q[Input] => (
	documentation => q[Grab input from various devices],
	is => q[rw],
	isa => q[KR_Input],
	lazy_build => 1,
	init_arg => q[input],
);

#==== Misc attributes

has q[NetCode] => (
	documentation => q[The Network Portion of this],
	is => q[rw],
	isa => q[KR],
	lazy_build => 1,
	init_arg => q[net],
);

#=== Methods
# blah!
# Right now, most of these need to be greately redefined. But for now, just 
# setting up a large amount of filler.
#
# You know what... will define most of these later.

#==== Doozers
# You may desire to cause much harm to me, BTW for this section heading

sub _build_logger {
	my $self = shift;
	inner();
}

#==== Whiteout
# Clear methods.

sub clear_config {
	my $self = shift;
	inner();
}

#==== Has function
# Do you has a flavour?

sub has_config {
	my $self = shift;
	inner();
}

#==== Logging and Profiling.
# This is mostly for debugging purposes.
# It should be noted that profiling/log levels _will_ be a configuration 
# method. So if you try to log something that the config says is not to be 
# logged it will simply just ignore that entry.
#
# Same goes for profiling. If the Config file says: "No Profiling", then no 
# Profiling will be done.

for local $_ (__PACKAGE__->meta->methods) {
	unless $_ eq "Logger" {
		before $_ => sub {
			my $self = shift;
			$self->Logger->push_profile($_);
			$self->Logger->info(qq[We are now headed into $_]);
		};
		after $_ => sub {
			my $self = shift;
			$self->Logger->pop_profile($_);
			$self->Logger->info(qq[We are now leaving $_]);
		};
	}
}

no MooseX::POE;
__PACKAGE__->meta->make_immutable();
POE::Kernel->run();

__END__;

=pod

=head1 Name

RaddTeam::KREPES 2d Gaming Engine

=head1 Overview

Kid Radd: KREPES is an attempt to make a 2d Platformer game engine in Perl 5.
KREPES stands for Kid Radd Existance Project Engine System. Yeah, Kid Radd: 
KREPES is kind of redundant. Sorry.

=head1 Synopsis

=head1 Description

=head1 See Also

=head1 Acknowledgements

Dan R. Miller (creator of all things Radd)
Jessie The Echidna
SilverJelly

#sdl on irc.perl.org
#mk and #KidRadd on irc.surrealchat.net
#perl on irc.freenode.net

=head1 Authors

Katrina "the Lamia" Payne AKA Full Metal Harlot.

=head1 Contributors

I see no X here.

=head1 Copyright and License

Written in 2009 by Katrina Payne.

This program is free software. As in free speech not free beer. You can 
redistribute it or modify it under the same terms as perl itself.