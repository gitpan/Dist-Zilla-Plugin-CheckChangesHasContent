use strict;
use warnings;
package Dist::Zilla::Plugin::Test::ChangesHasContent;
# ABSTRACT: Release test to ensure Changes has content
our $VERSION = '0.006'; # VERSION

# Dependencies
use Dist::Zilla;
use autodie 2.00;
use Moose 0.99;
use namespace::autoclean 0.09;

# extends, roles, attributes, etc.

extends 'Dist::Zilla::Plugin::InlineFiles';
with qw/Dist::Zilla::Role::TextTemplate/;

has changelog => (
  is => 'ro',
  isa => 'Str',
  default => 'Changes'
);

has trial_token => (
  is => 'ro',
  isa => 'Str',
  default => '-TRIAL'
);

# methods

around add_file => sub {
    my ($orig, $self, $file) = @_;
    return $self->$orig(
        Dist::Zilla::File::InMemory->new(
            name    => $file->name,
            content => $self->fill_in_string($file->content,
                {
                    changelog => $self->changelog,
                    trial_token => $self->trial_token,
                    newver => $self->zilla->version
                }
            )
        )
    );
};

__PACKAGE__->meta->make_immutable;

1;

# Pod must be before DATA




=pod

=head1 NAME

Dist::Zilla::Plugin::Test::ChangesHasContent - Release test to ensure Changes has content

=head1 VERSION

version 0.006

=head1 SYNOPSIS

   # in dist.ini
 
   [Test::ChangesHasContent]

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the following file:

=over

=item *

xtE<sol>releaseE<sol>changes_has_content.t

=back

This test ensures ensures that your Changes file actually has some content
since the last release.

This can be contrasted to L<Dist::Zilla::Plugin::CheckChangesHasContent>, which
performs the check at release time, halting the release process if content is
missing.  Performing the check as a test makes it possible to check more
frequently, and closer to the point of development.

The algorithm is very naive.  It looks for an unindented line starting with
the version to be released.  It then looks for any text from that line until
the next unindented line (or the end of the file), ignoring whitespace.

For example, in the file below, algorithm will find "- blah blah blah":

   Changes file for Foo-Bar
 
   {{$NEXT}}
 
     - blah blah blah
 
   0.001  Wed May 12 13:49:13 EDT 2010
 
     - the first release

If you had nothing but whitespace between C<<<  {{$NEXT}}  >>> and C<<<  0.001  >>>,
the release would be halted.

If you name your change log something other than "Changes", you can configure
the name with the C<<< changelog >>> argument:

   [Test::ChangesHasContent]
   changelog = ChangeLog

=head1 SEE ALSO

=over

=item *

L<Dist::Zilla::Plugin::CheckChangesHasContent>

=item *

L<Dist::Zilla>

=back

=head1 AUTHORS

=over 4

=item *

David Golden <dagolden@cpan.org>

=item *

Karen Etheridge <ether@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut


__DATA__
___[ xt/release/changes_has_content.t ]___
#!perl

use Test::More tests => 2;

note 'Checking Changes';
my $changes_file = '{{$changelog}}';
my $newver = '{{$newver}}';
my $trial_token = '{{$trial_token}}';

SKIP: {
    ok(-e $changes_file, "$changes_file file exists")
        or skip 'Changes is missing', 1;

    ok(_get_changes($newver), "$changes_file has content for $newver");
}

done_testing;

# _get_changes copied and adapted from Dist::Zilla::Plugin::Git::Commit
# by Jerome Quelin
sub _get_changes
{
    my $newver = shift;

    # parse changelog to find commit message
    open(my $fh, '<', $changes_file) or die "cannot open $changes_file: $!";
    my $changelog = join('', <$fh>);
    close $fh;

    my @content =
        grep { /^$newver(?:$trial_token)?(?:\s+|$)/ ... /^\S/ } # from newver to un-indented
        split /\n/, $changelog;
    shift @content; # drop the version line

    # drop unindented last line and trailing blank lines
    pop @content while ( @content && $content[-1] =~ /^(?:\S|\s*$)/ );

    # return number of non-blank lines
    return scalar @content;
}

__END__
