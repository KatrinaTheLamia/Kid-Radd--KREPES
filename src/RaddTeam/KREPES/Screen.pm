=cut
#= Kid Radd: KREPES: Screen
# Project   : Kid Radd: KREPES
# File      : <KREPES root>/src/RaddTeam/KREPES/Screen.pm
# Group     : NIMH Labs, Radd Team
# Authors   : Katrina "the Lamia" Payne AKA FullMetalHarlot
# Copyright : <KREPES root>/Documentation/COPYRIGHT.txt
# Licenses  : <KREPES root>/Documentation/LICENSES.txt
#== Purpose
# This is mostly a typing system for within Kid Radd KREPES.

package RaddTeam::KREPES::Screen;

#= Versioning.
# What version am I?
our $VERSION = v0.0.2;

#= Includes
#== Standard Includes
# Makes use of MooseX::POE, SDL and Carp
use MooseX::POE;
use SDL;
use Carp;

#== Internal Includes
# My own stuff for this project

use RaddTeam::KREPES::Screen::Kanvas;

#= Inheritance
# We are pretty much a glorified Kanvas here. Just with some extra features.

our @ISA = qw(RaddTeam::KREPES);

#= Attributes

has Screen_Title => (
	documentation => q[What will this screen be named?],
	is => q[rw],
	isa => q[Str],
	lazy => 1,
	required => 1,
	trigger => \&my_update_title,
);

has Screen_Icon => (
	documenation => q[Optional: an Icon for the screen],
	is => q[rw],
	isa => q[KR::Kanvas],
	lazy => 1,
	trigger => \&my_update_icon,
);

has Screen_Icon_Title => (
	documentaton => q[Optional: a title|Caption for the screen's Icon],
	is => q[rw],
	isa => q[Str],
	lazy => 1,
	trigger => \&my_update_title,
);

has OutPut => (
	documentation => q[The out buffer],
	is => q[r],
	isa => q[Item],
	lazy => 1,
	require => 1,
);

has qw[offset_x offset_y] => (
	documentation => q[View port dimension information],
	is => q[r],
	isa => q[KR::ABSInt],
	lazy => 1,
	required => 1,
	trigger => \%move_camera,
);

has refresh_rate => (
	is => q[rw],
	isa => q[KR::Microseconds],
	lazy => 1,
	required => 1,
);

has refrest_last => (
	is => q[r],
	isa => q[KR::Microseconds],
	lazy => 1,
	required => 1,
);

has flags => (
	is => q[rw],
	isa => q[Item],
	lazy => 1,
	required => 1,
	trigger => \&schedule_flag_update,
);

has levels => (
	is => q[rw],
	isa => q[ArrayRef[Levels]],
	lazy => 1,
	required => 1,
);

has current_level => (
	is => q[rw],
	isa => q[ScalarRef],
	lazy => 1,
	required => 1,
);

#= Constructors
# The STARTALL constructor

method START() {
	my @error = [];
	my $type = ref($self)
		|| confess sprintf(q[in %s, %s, does not appear to be an object, but called the START()],
			qw[__PACKAGE__ $self];
	confess sprintf(q[in %s (instance %s) trying to start is up MooseX::POE but I do not see our App.],
		qw[__PACKAGE__ $self]) 
			unless($self->has_App_Reference);
	# Set up the delay/timers, and load their errors in @error
	push(@error, $self->yield('draw'));
	# Other events go here...
	
	$self->refresh_last([get_time_of_day()]);
	# Here we go through all the errors
	if(scalar(@error)) {
		for local $_ (@error) {
			$self->App_Reference->Logger->error(new KR:Exception(
				-name => q[POE Event Error],
				-messages => q[In %s (instance %s) got a POE Error %u: %s],
				-variables => q[__PACKAGE__ $self $_ $_]));
		}
	}
}

#= Methods
# Since deciding to go with an event based system, most methods are to be 
# called based on their events, rather than directly. Since most of these will 
# be called based upon

method my_update_icon() {
	my $type = ref($self)
		|| confess sprintf(q[in %s, %s does not appear to be an object, but called method my_update_icon], 
			qw[__PACKAGE__ $self]);
	SDL::WMSetIcon($self->Screen_Icon) if $self->has_Screen_Icon();
	inner();
};

method my_update_title() {
	my $type = ref($self) 
		|| confess sprintf(q[in %s, %s does not appear to be an object, but called private method _update_title], 
			qw[__PACKAGE__ $self]);
	if($self->has_Screen_Icon_Title() && $self->has_Screen_Title()) {
		SDL::WMSetCaption($self->Screen_Title, $self->Screen_Icon_Title);
	} elif ($self->has_Screen_Title()) {
		SDL::WMSetCaption($self->Screen_Title);
	} else {
		if(not $self->has_App_Reference()) {
			confess sprintf(q[%s cannot talk to the app, and there was an error], 
				qw[__PACKAGE__]);
		} else {
			$self->App_Reference->Logger->error(new KR:Exception(
				-name => q[Undefined Variable],
				-message => q[%s does not have a title. You may want to look into this.],
				-variables => qw[__PACKAGE__]));
		}
	}
	inner();
}

method my_init_window() {
	my $type = ref($self)
		|| confess sprintf(q[in %s init_window event is called by %s, and %s does not appear to be a valid object], 
			qw[__PACKAGE__ $self $self]);
	
	confess sprintf(q[The %s cannot talk to the app, in init_window function, and there was an error], 
		qw[__PACKAGE__])
			unless($self->has_App_Reference());

	$self->checking_set(__PACKAGE__, q[init application], q[width], \$self->has_width);
	$self->checking_set(__PACKAGE__, q[init application], q[height], \$self->has_height);
	$self->checking_set(__PACKAGE__, q[init application], q[depth], \$self->has_depth);

	$self->OutPut = \SDL::SetVideoMode($self->width, $self->height, $self->depth, $self->flags)
		|| $self->App_Reference->Logger->error(new KR:Exception(
			-name => q[API Error],
			-message => q[running an initiation on %s (instance %s) and got an error: %s], 
			-variables => qw[__PACKAGE__ $self SDL::GetError()]));
	
	inner();
}

#= Move the camera
# Changing the x or y offset will switch where he camera is
method move_camera() {
	my $type = ref($self)
		|| confess sprintf(q[In %s (instance: %s) trying to move the camera, but %s does not appear to be an object],
			qw[__PACKAGE__ $self $self]);
	confess sprintf(q[In %s (instance: %s) trying to move the camera, but cannot find the App],
		qw[__PACKAGE__ $self]) 
			unless($self->has_App_Reference);
	$self->checking_set(__PACKAGE__, q[move camera], q[x offset], \$self->has_offset_x);
	$self->checking_set(__PACKAGE__, q[move camera], q[y offset], \$self->has_offset_y);
	inner();
}

#=Events

event draw => sub {
	my @error = [];
	my $self = shift;
	my $type = ref($self)
		|| confess sprintf(q[In %s (instance: %s) trying to draw to the screen, but %s does not appear to be an object],
			qw[__PACKAGE__ $self $self]);
	confess sprintf(q[In %s instance of %s we are trying to draw to the screen... but we cannot find the app], 
		qw[__PACKAGE__ $self])
			unless($self->has_App_Reference);
	unless($self->has_refresh_last) {
		$self->App_Reference->Warning(new KR:Exception(
			--name => q[Undefined Variable],
			--message=> q[In %s (instance: %s), we do not see to have a last refresh time Creating a new one],
			--variables => q[__PACKAGE__ $self]));
		$self->refresh_last([get_time_of_day()]);
	}
	
	if(tv_interval($self->refresh_last, get_time_of_day()) < $self->refresh_rate) {
		$self->checking_set(__PACKAGE__, q[draw (event)], q[refresh rate], \$self->has_refrest_rate);
		$self->checking_set(__PACKAGE__, q[draw (event)], q[OutPut], \$self->has_OutPut);
		$self->checking_set(__PACKAGE__, q[draw (event)], q[OutPut], \$self->has_offset_x);
		$self->checking_set(__PACKAGE__, q[draw (event)], q[OutPut], \$self->has_offset_y);
		$self->checking_set(__PACKAGE__, q[draw (event)], q[OutPut], \$self->has_levels);
		$self->checking_set(__PACKAGE__, q[draw (event)], q[OutPut], \$self->has_levels_current);

		# This mostly using coercion to do its stuff
		$self->OutPut->blit(KR:SDL:Surface($self));
		$self->flip();
		$self->refrest_last([get_time_of_day()]);
	}
	$self->my_blit($self->levels[$self->current_level]->grab_spot($self->offset_x, $self->offset_y), $self->offset_x, $self->offset_y);
	my @error;
	push(@error, $self->yield('draw'));
	if(scalar(@error)) {
		for local $_ (@error) {
			$self->App_Reference->Logger->error(new KR:Exception(
				-name => q[POE Event Error],
				-messages => q[In %s (instance %s) got a POE Error %u: %s],
				-variables => q[__PACKAGE__ $self $_ $_]));
		}
	}
};

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

#= closing
# standard closing stuff here
no MooseX::POE;
__PACKAGE__->meta->make_immutable();
1;

__END__;

=pod

=head1 Name

RaddTeam::KREPES::Screen (extends RaddTeam::KREPES::Screen::Kanvas)

Graphical output... HOORAY!

=head1 Description

A general purpose screen that could be modified based on the game that is 
using it. Right now, very messy.

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