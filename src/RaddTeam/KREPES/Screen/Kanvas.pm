=cut
#= Kid Radd: KREPES: Screen: Kanvas
# Project   : Kid Radd: KREPES
# File      : <KREPES root>/src/RaddTeam/KREPES/Screen/Kanvas.pm
# Group     : NIMH Labs, Radd Team
# Authors   : Katrina "the Lamia" Payne AKA FullMetalHarlot
# Copyright : <KREPES root>/Documentation/COPYRIGHT.txt
# Licenses  : <KREPES root>/Documentation/LICENSES.txt
#== Purpose
# This is mostly a typing system for within Kid Radd KREPES.

package RaddTeam::KREPES::Screen::Kanvas;

#= Versioning.
# What version are we?
our $VERSION = v0.0.1;

#= Includes
#== Standard Includes
# we make use of Moose, SDL and Image::Magick
use MooseX::POE qw[events];
use MooseX::Params::Validate;
use SDL;
# use Image::Magick
use Carp;

#==  Internal Includes
# My own stuff.

use RaddTeam::KREPES::Widget

#= Inheritance
# What is it?... it would be, of course a RaddTeam:KREPES::Widget

our @ISA = qw[RaddTeam::KREPES::Widget];

#= Flags
# Mostly just a set of enum that are only used here so there is no reason to
# put them in Types.

#== Internal Rendering
# Well, since we will be using Image Magick to generate out imagery before 
# sending them out to SDL, since this would allow for a much larger range of 
# input graphical types to be used, I figured, why not just let Image Magick 
# take care of how things are slapped onto each other.
#
# This allows for some different choices in how graphics are internally 
# rendered. This option is different for each of these KR::Kanvas. However 
# once something is blitted onto one of these, it will likely be converted to  
# the format of that KR::Kanvas
#
# '''TIFF''': Exceedingly high quality. However this likely will be very slow 
# and take up lots of RAM. However it will look nice.
# '''BMP''': This is normally the stardard method for this sort of thing.
# '''PNG''': This will use less memory (in hypothesis) but will likely use 
# slightly more CPU.
# '''JIFF''': I figured I'd add this into here, in the case this particular 
# KR::Kanvas entry loads from a JIFF
# '''SVG''': included for now, however it likely will not be implemented for 
# some time.

enum q[KR:Internal_Rendering] => qw[
	KR:Image:TIFF
	KR:Image:BMP
	KR:Image:PNG
	KR:Image:JIFF
	KR:Image:SVG
];

#= Attributes
# What does this object have in it?

#== Width/Height
# It should be noted that a width|height of zero is perfectly valid for a 
# KR::Kanvas.
for local $_ (qw[width height]) {
	has qw[width height] => (
		is => q[rw],
		isa => q[KR::ABSInt],
		lazy => 1,
		required => 1,
		trigger => \&my_boundry_change,
		init_arg => $_,
	};
)

#== Depth
# Default bit depth of this KR::Kanvas
has depth => (
	is => q[rw],
	isa => q[KR::BitDepth],
	lazy => 1,
	required => 1,
	trigger => \&my_modify_depth,
);

#== Internal Render
# The value for our internal render
has internal_render => (
	is => q[rw],
	isa => q[KR::Internal_Rendering],
	lazy => 1,
	required => 1,
	trigger => \%my_convert_canvas,
);

#== Buffer
# The image contents
# Will be updated when I get the ImageMagick code into here
has image_buffer => (
	is => q[r],
	isa => q[Item],
	lazy => 1,
	required => 1,
);

#= Methods
# Methods of this Object. Generally stuff should be handled by events and just 
# changing the data.
#
# With most of the builder stuff, these will likely be reset by loading 
# the Canvas itself

#== Width Default
# Using 1 as a default width
sub build_width {
	my $self = shift;
	my $type = ref($self)
		|| confess(sprintf(q[Trying to build width in %s, but %s is not an object],
			qw[__PACKAGE__ $self]));
	return inner() or 1;
}

#== Height Default
# Using 1 as a default height
sub build_height {
	my $self = shift;
	my $type = ref($self)
		|| confess(sprintf(q[Trying to build height in %s, but %s is not an object],
			qw[__PACKAGE__ $self]));
	return inner() or 1;
}

#== Default Depth
# Going with the overly high depth of 32.
sub build_depth {
	my $self = shift;
	my $type = ref($self)
		|| confess(sprintf(q[Trying to build depth in %s, but %s is not an object],
			qw[__PACKAGE__ $self]));
	return inner() or 32;
}

#== Internal Renderer Default
# Defaults to BMP.
sub build_internal_renderer {
	my $self = shift;
	my $type = ref($self)
		|| confess(sprintf(q[Trying to set internal renderer in %s, but %s is not an object],
			qw[__PACKAGE__ $self]));
	return inner() or KR:Image:BMP;
}

#== change the boundry
# this is a stub currently. Will work on making it so it uses ImageMagick to
# change the image's boundry appropriately
sub my_boundry_change {
	my $self = shift;
	my $type = ref($self)
		|| confess(sprintf(q[%s's method boundry change was called by %s. %s does not appear to be an Object], 
			qw[__PACKAGE__ $self $self]));
	confess(sprintf(q[%s is trying to do a boundry change, but it cannot talk to the App], qw[__PACKAGE__]))
		unless($self->has_App_Reference);
	$self->checking_set(__PACKAGE__, q[boundry change], q[width], \$self->has_width);
	$self->checking_set(__PACKAGE__, q[boundry change], q[height], \$self->has_height);
	inner();
}

#== Depth change
# not much here.
sub my_depth_change {
	my $self = shift;
	my $type = ref($self)
		|| confess sprintf(q[%s's depth change was called by %s, but %s does not appear to be an object.],
			qw[__PACKAGE__ $self $self]);
	confess sprintf(q[%s is trying to do a depth change but cannot find the application],
		qw[__PACKAGE__])
			unless($self->has_App_Reference);
	
	$self->checking_set(__PACKAGE__, q[depth charge], q[colour depth], \$self->has_depth);
	inner();
}

#== Convert our Rendering
# again, not much here.
# will update this for we I am using Image Magick
sub my_convert_canvas {
	my $self = shift;
	my $type = ref($self)
		|| confess sprintf(q[%s is trying to convert itself to another type vai %s, but %s does not appear to be an object],
			qw[__PACKAGE__ $self $self]);
	confess sprintf(q[%s is tring to convert itself to another type, but cannot find the application],
		qw[__PACKAGE__]) 
			unless($self->has_App_Reference);
	$self->checking_set(__PACKAGE__, q[render charge], q[render type], \$self->has_internal_renderer);
	inner();
}

#== Blit to image
# put another image into this Kanvas. Nothing here yet, BTW.
method my_blit(KR:Kanvas $onto_here, Int X, Int Y) {
	my $type = ref($self)
		|| confess sprintf(q[%s is trying to blit something to it vai %s, but %s does not appear to be an object],
			qw[__PACKAGE__ $self $self]);
	confess sprintf(q[%s is trying to blit something onto itself, but cannont find the application],
		qw[__PACKAGE__])
			unless($self->has_App_Reference);
	unless($self->has_image_buffer()) {
		$self->App_Reference->warning(new KR:Exception(
			--name => q[Undefined Variable],
			--mesage => q[Trying to blit to %s (instance: %s), but there is nothing to blit to. Defaulting to copying %s (instance %s) here],
			--variables => qw[__PACKAGE__ $self $onto_here->__PACKAGE__ $onto_here]))
		$self = $onto_here;
	}
	inner();
}

#= Events
# Not much here

for local $_ (__PACKAGE__->meta->methods) {
	unless($_ eq "App_Reference") {
		before $_ => sub {
			my $self = shift;
			my $type = ref($self)
				|| confess sprintf(q[called the %s before event in %s however passed %s does not appear to be an object],
					qw[$_ __PACKAGE__ $self]);
			confess sprintf(q[in %s before event in %s we are having issues talking to the App], 
				qw[$_ __PACKAGE__])
					unless($self->has_App_Reference)
			$self->App_Reference->Logger->push_profile(__PACKAGE__, $_);
			$self->App_Reference->Logger->info(new KR:Info(
				-name => q[entering function],
				-message => q[We are now headed into %s]
				-variables => qw[$_]));
		};
		after $_ => sub {
			my $self = shift;
			my $self = shift;
			my $type = ref($self)
				|| confess sprintf(q[called the %s before event in %s however passed %s does not appear to be an object],
					qw[$_ __PACKAGE__ $self]);
			confess sprintf(q[in %s before event in %s we are having issues talking to the App], 
				qw[$_ __PACKAGE__])
					unless($self->has_App_Reference)
			$self->App_Reference->Logger->pop_profile(__PACKAGE__, $_);
			$self->App_Reference->Logger->info(new KR:Info(
				-name => q[leaving function],
				-message => q[now exiting from %s],
				-variables => qw[$_]));
		};
	}
}

no Moose::POE;
__PACKAGE__->meta->make_immutable();
1;

__END__;

=pod

=head1 Name

RaddTeam::KREPES::Screen::Kanvas (extends RaddTeam::KREPES::Widget)

The graphics information used in KREPES

=head1 Description

A form of standard graphic type used in Kid Radd: KREPES. 

=head1 See Also

RaddTeam::KREPES::Manual RaddTeam::KREPES::Screen::Kanvas

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