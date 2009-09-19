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

package RaddTeam::KREPES::Widget;

#= Versioning.
# What version are we?
our $VERSION = v0.0.1;

use MooseX::POE qw[events];

#= Attributes
# Attributes of KR:Widget base type.

#== App_Reference
# a callback method. Generally should be called whenever anything is called.
has App_Reference => (
	documention => q[callback to the main app. Allows for multiple Apps to exist at once, and doesn't require a global],
	is => q[r],
	isa => q[RaddTeam::KREPES],
	weak_ref => 1,
	lazy => 1,
	require => 1,
	init_arg => application
);

#= Methods
# Well, looks like KR:Widget has Methods

method checking_set(Str $Package, Str $Function, Str $Variable_Name, CodeRef $test) {
	my $type = ref($self)
		|| confess sprintf(q[in %s (instance %s) we are checking_set... and as odd as it may be, %s does not appear to be an object],
			qw[__PACKAGE__ $self $self]);
	confess sprintf(q[in %s (instance %s) we are more than having a little issues doing a diagnostic "checking_set", as where we are reporting the diagnostic to (the Application) is missing], 
		qw[__PACKAGE__ $self])
			unless($self->has_App_Reference);
	return unless($self->App_Reference->Config->Debug->checking_set())
	$self->App_Reference->Logger->error(new KR:Exception(
		--name => q[Undefined Variable],
		--message => q[In %s (instance: %s)'s %s we couldn't find %s],
		--variables => qw[$Package $self $Function, $Variable_Name])) 
			unless(&$test)
}

no MooseX::POE;
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
#perl and #perl6 on irc.freenode.net

=head1 Authors

Katrina "the Lamia" Payne AKA Full Metal Harlot.

=head1 Contributors

I see no X here.

=head1 Copyright and License

Written in 2009 by Katrina Payne.

This program is free software. As in free speech not free beer. You can 
redistribute it or modify it under the same terms as perl itself.