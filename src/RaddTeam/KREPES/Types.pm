#!/usr/bin/perl -Tw
#=cut
#= Kid Radd: KREPES: Types
# Project   : Kid Radd: KREPES: Types
# File      : <KREPES root>/src/RaddTeam/KREPES/Types.pm
# Group     : NIMH Labs, Radd Team
# Authors   : Katrina "the Lamia" Payne AKA FullMetalHarlot
# Copyright : <KREPES root>/Documentation/COPYRIGHT.txt
# Licenses  : <KREPES root>/Documentation/LICENSES.txt
#== Purpose
# This is mostly a typing system for within Kid Radd KREPES.
package RaddTeam::KREPES::Types;

# Versioning.
our $VERSION = v0.0.1;

# Declare the types we will be defining.
use MooseX::Types 
	-declare => [qw(
		KR_Logger KR_Screen KR_Speakers
		KR_Config KR_Input
		KR_Network
	)];

#= View: Logger
# one thing that KREPES will require is a rather intense debugging system, 
# that allows for debugging to be done a _lot_ easier. It also allows for 
# when the users make use of games, for when they _do_ get errors, for them
# to be better debugged.
use RaddTeam::KREPES::Logger;

subtype KR::Logger,
	as RaddTeam::KREPES::Logger,
	where { $_->isa(q[RaddTeam::KREPES::Logger]) },
	message { q[that is not a valid logging class] };

#= View: Screen
# Well, rather then labelling these their usual MVC types, even though that 
# is largely what they _are_ instead we simply are going to name them rather 
# logical names for them. First we have Screen, which will largely be write
# only, with a few things you can read. I am pretty certain that a monitor 
# counts as being fairly close to write only memory. I mean, yes, you can 
# read bits of stuff, but that generally is only stuff on the _buffer_ headed 
# to the monitor itself.
use RaddTeam::KREPES::Screen;

subtype KR::Screen,
	as RaddTeam::KREPES::Screen,
	where { $_->isa(q[RaddTeam::KREPES::Screen]) },
	message { q[this does not appear to be a screen I can talk to] };

#= Speaker
# This is where the (nonexistant) sound code will go.
use RaddTeam::KREPES::Speakers;

subtype KR::Speakers,
	as RaddTeam::KREPES::Speakers,
	where { $_->isa(q[RaddTeam::KREPES::Speakers]) },
	message { q[I don't know how to talk to those] };

#= Controller: Config
# This config system will mostly just be a wrapper for the Perl Configuration 
# libraries themselves, but will mostly be done this way to allow for multiple 
# ways to load/cache/execute configuration data. Some thoughts at this point 
# include *.ini config files, *conf style config, and Lua based config files.
# Also caching ideas would include things like caching to an SQLite database, 
# for easier storage, or in some cases encrypting cached configuration files.
# I hope mostly to move this from outside of RaddTeam::KREPES into RaddTeam
# itself.
use RaddTeam::KREPES::Config;

subtype KR::Config,
	as RaddTeam::KREPES::Config,
	where { $_->isa(q[RaddTeam::KREPES::Config]) },
	message {q[this config file doesn't make any sense to me.] };

#= Controller: Input
# Just basic input device like a keyboard, mouse or a joystick.
#
# Trackballs too... maybe... just... maybe
use RaddTeam::KREPES::Input;

subtype KR::Input,
	as RaddTeam::KREPES::Input,
	where { $_->isa(q[RaddTeam::KREPES::Input]) },
	message { q[That player input is not something I can understand] };

#= Misc: Network
# MVC code is put _inside_ the network code. As it would be silly to have
# a "device" for talking to the network, and a "device" for hearing the 
# network. This may change in future occurances of this program.

use RaddTeam::KREPES::Network;

subtype KR::NetCode,
	as RaddTeam::KREPES::Network,
	where { $_->isa(q[RaddTeam::KREPES::Network]) },
	message { q[this cannot make me talk to the net] };

#= Exporters
# Not sure if these will work.
type_export_generator();
check_export_generator();

1;

__END__

=pod

=head1 Name

RaddTeam::KREPES::Types

=head1 Description

Commonly used types throughout KREPE. Currently very slim in what it has.
However, we hope to have a fair amount more... soon...

=head1 Types

KR::Logger: an alias for RaddTeam::KREPES::Logger

KR::Screen: an alias for RaddTeam::KREPES::Screen

KR::Speakers: an alias for RaddTeam::KREPES::Speakers

KR::Config: an alias for RaddTeam::KREPES::Config

KR::Input: an alias for RaddTeam::KREPES::Input

KR::NetCode: an alias for RaddTeam::KREPES::NetCode

=head1 Caveats

We are kind of hijacking the namespace the 'KR' namespace for use as a 
shortcut. This may cause issues with other programs running with the same 
types defined. Just a heads up.

=head1 See Also

RaddTeam::KREPES, RaddTeam::KREPES::Logger, RaddTeam::KREPES::Screen, 
RaddTeam::KREPES::Speakers, RaddTeam::KREPES::Config, RaddTeam::KREPES::Input 
RaddTeam::KREPES::Network

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