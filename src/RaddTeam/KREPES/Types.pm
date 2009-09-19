#=cut
#= Kid Radd: KREPES: Types
# Project   : Kid Radd: KREPES
# File      : <KREPES root>/src/RaddTeam/KREPES/Types.pm
# Group     : NIMH Labs, Radd Team
# Authors   : Katrina "the Lamia" Payne AKA FullMetalHarlot
# Copyright : <KREPES root>/Documentation/COPYRIGHT.txt
# Licenses  : <KREPES root>/Documentation/LICENSES.txt
#== Purpose
# This is mostly a typing system for within Kid Radd KREPES.
package RaddTeam::KREPES::Types;

# Versioning.
our $VERSION = v0.0.2;

# Declare the types we will be defining.
use MooseX::Types 
	-declare => [ qw[
		KR:ABSInt
		KR:Screen KR:Speakers
		KR:Config KR:Input
		KR:NetCode KR:Logger
		KR:Canvas KR:Kanvas KR:BitDepth
		KR:Ticks KR:Milliseconds
	]];
use MooseX::Types::Moose qw[Int];

#= Basic
#== KR:ABSInt
# Well, The Moose docs usually refer to this as "PositiveInt". I am going to 
# say: for the purposes of KREPES, this will be more of an ABS value. Mostly 
# because nothing is to say this _cannot_ hold a negative number, or be used 
# for a count down. I mean, why does there need to be a type for both Positive 
# an Negative numbers (like suggested in the Moose Manual)? Surely a single 
# Absolute Value Int type would work just fine.
#
# Loaded into KR, rather than the main, because pollution is wrong kids.

subtype KR:ABSInt,
	as Int,
	where { 1 },
	message { q[I congradulate you. This error message should not appear] };

coerce KR:ABSInt,
	from Int,
	via { abs };


#= View
# In other words "Output devices"

#== KR:Screen
# Well, rather then labelling these their usual MVC types, even though that 
# is largely what they _are_ instead we simply are going to name them rather 
# logical names for them. First we have Screen, which will largely be write
# only, with a few things you can read. I am pretty certain that a monitor 
# counts as being fairly close to write only memory. I mean, yes, you can 
# read bits of stuff, but that generally is only stuff on the _buffer_ headed 
# to the monitor itself.
use RaddTeam::KREPES::Screen;

subtype KR:Screen,
	as RaddTeam::KREPES::Screen,
	where { $_->isa(q[RaddTeam::KREPES::Screen]) },
	message { q[this does not appear to be a screen I can talk to] };

#== KR:Speaker
# This is where the (nonexistant) sound code will go.
use RaddTeam::KREPES::Speakers;

subtype KR:Speakers,
	as RaddTeam::KREPES::Speakers,
	where { $_->isa(q[RaddTeam::KREPES::Speakers]) },
	message { q[I don't know how to talk to those] };

#= Controller
# Input devices.

#== KR:Config
# This config system will mostly just be a wrapper for the Perl Configuration 
# libraries themselves, but will mostly be done this way to allow for multiple 
# ways to load/cache/execute configuration data. Some thoughts at this point 
# include *.ini config files, *conf style config, and Lua based config files.
# Also caching ideas would include things like caching to an SQLite database, 
# for easier storage, or in some cases encrypting cached configuration files.
# I hope mostly to move this from outside of RaddTeam::KREPES into RaddTeam
# itself.
use RaddTeam::KREPES::Config;

subtype KR:Config,
	as RaddTeam::KREPES::Config,
	where { $_->isa(q[RaddTeam::KREPES::Config]) },
	message {q[this config file doesn't make any sense to me.] };

#== KR::Input
# Just basic input device like a keyboard, mouse or a joystick.
#
# Trackballs too... maybe... just... maybe
use RaddTeam::KREPES::Input;

subtype KR:Input,
	as RaddTeam::KREPES::Input,
	where { $_->isa(q[RaddTeam::KREPES::Input]) },
	message { q[That player input is not something I can understand] };

#= IO
# Input/Output devices. Generally require their own logic, but when talking to 
# then, mostly will just get/set

#== KR::Logger
# one thing that KREPES will require is a rather intense debugging system, 
# that allows for debugging to be done a _lot_ easier. It also allows for 
# when the users make use of games, for when they _do_ get errors, for them
# to be better debugged.
#
# '''Update 20090919''': This is to be given network functionality, and 
# Moved to Input/Output devices
use RaddTeam::KREPES::Logger;

subtype KR:Logger,
	as RaddTeam::KREPES::Logger,
	where { $_->isa(q[RaddTeam::KREPES::Logger]) },
	message { q[that is not a valid logging class] };

#= IO: KR:NetCode
# MVC code is put _inside_ the network code. As it would be silly to have
# a "device" for talking to the network, and a "device" for hearing the 
# network. This may change in future occurances of this program.
#
# I've decide that rather than use send/recv, I'll gather things via, get/set
# and ask for socket data.

use RaddTeam::KREPES::Network;

subtype KR:NetCode,
	as RaddTeam::KREPES::Network,
	where { $_->isa(q[RaddTeam::KREPES::Network]) },
	message { q[this cannot make me talk to the net] };

#= Graphics: KR:Kanvas
# Generally how we store graphics. I kind of want to get this tool kit 
# decent enough to support, BMP, GIF, PNG, MNG, JIFF, TIFF, XCF (GIMP), 
# PSD (Photoshop), EPS (Encapsulated Postscript), RAW, SVG, PS, 
# AI (Illustrator) amongst a large amount of others. Most of which is _well_
# beyond what libSDL offers for support.
#
# Coercion for this type will be located relative to RaddTeam::Screen::Kanvas 
# rather than in here. As it would likely be rather nuts, TBH.

use RaddTeam::KREPES::Screen::Kanvas

subtype KR:Kanvas,
	as RaddTeam::KREPES::Screen::Kanvas,
	where { $_->isa(q[RaddTeam::KREPES::Screen::Kanvas]) },
	message { q[this does not appear to be a valid KR::Kanvas] };

#= Graphics: KR:Canvas
# An alias to KR:Kanvas. You may be feeling sorry for KR:Canvas not being 
# the prefered data type. This is because you are stupid. KR:Kanvas is much 
# better.
#
# For those of you who do not know, I'll prolly be making large amounts of 
# references to an old IKEA commercial with this one. Mostly as a satire of my 
# own choice to use KR:Kanvas as a term, instead of KR:Canvas.

subtype KR:Canvas,
	as KR:Kanvas,
	where { $_->isa(q[KR:Kanvas])},
	message { q[You appear to not being using KR::Kanvas. This is because you are stupid. KR:Kanvas is much better.] };

#= Graphics: KR:BitDepth
# Right now just a nonzero KR:ABSInt. Mostly used for explicidly stating the 
# bit depth of an entry in KRIME.

subtype KR:BitDepth,
	as KR:ABSInt,
	where { $_ > 0},
	message { q[You cannot have a Bit Depth of Zero or a Negative Number (though the value fed to KR:BitDepth should automagically have abs ran on it anyways)] };

#= Timers: KR:Ticks
# Well for most of today's computers timers are linear and only move in one 
# direction. Hopefully constantly.
#
# So, KR:Ticks will be a positive Int named all fancy like.

subtype KR:Ticks,
	as KR:ABSInt,
	where { $_ > 0 },
	message { q[This appears to be an invalid value for a tick] };

# Automatically increment the tick give here. Mostly just a safe guard incase 
# it has 0 passed to it.
coerce KR:Ticks,
	from KR:ABSInt,
	via { $_ + 1 };

#=Timers: KR:Milli_Seconds
# Mostly for when we base it on important timing things, where cycles are not 
# so much important.

subtype KR:Milliseconds,
	as DateTime,
	where { 1 },
	message { q[this error message _really_ needs to be changed, BTW. ] };

#= Exporters
# Not sure if these will work.
type_export_generator();
check_export_generator();

1;

__END__

=pod

=head1 Name

RaddTeam::KREPES::Types

The types within KREPES itself.

=head1 Description

Commonly used types throughout KREPE. Currently very slim in what it has.
However, we hope to have a fair amount more... soon...

=head1 Types

KR::ABSInt: My answer to PostiveInt and NegativeInt types given elsewhere. 
=over 12
Originally, this was to be KR::UnsignedInt, but I felt that kind of did not 
propperly describe what I was doing.
=back 

KR::Screen: an alias for RaddTeam::KREPES::Screen

KR::Speakers: an alias for RaddTeam::KREPES::Speakers

KR::Config: an alias for RaddTeam::KREPES::Config

KR::Input: an alias for RaddTeam::KREPES::Input

KR::NetCode: an alias for RaddTeam::KREPES::NetCode

KR::Logger: an alias for RaddTeam::KREPES::Logger

KR::Canvas KR::Kanvas: an alias for RaddTeam::KREPES::Screen::Kanvas . Use
=over 23
of KR::Kanvas is prefered, but some programmers may prefer to use KR::Canvas. 
It is because they are stupid. KR::Kanvas is much better.
=back

KR::BitDepth : How many bits a screen can have. Will be working this into a 
=over 15
more involved type, BTW.
=back

KR::Ticks : Number measuring "CPU Cycles" being used.

KR::Milliseconds : A number denoting milliseconds.

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