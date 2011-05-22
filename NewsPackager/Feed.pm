package NewsPackager::Feed;

use strict;
use warnings;

use HTML::Entities;
use HTML::Strip;
use Encode qw/encode/;

sub new() {
	my ($class) = @_;
	
	return bless({}, ref $class || $class);
}

sub title(;$) {
	my ($self, $title) = @_;
	
	if ($title) {
		$self->{_TITLE} = __Tidy($title);
	}
	else {
		return $self->{_TITLE};
	}
}

sub summary(;$) {
	my ($self, $summary) = @_;
	
	if ($summary) {
		$self->{_SUMMARY} = __Tidy($summary);
	}
	else {
		return $self->{_SUMMARY};
	}
}

sub content(;$) {
	my ($self, $content) = @_;
	
	if ($content) {
		$self->{_CONTENT} = encode('UTF-8', $content);
	}
	else {
		return $self->{_CONTENT};
	}
}

sub url(;$) {
	my ($self, $url) = @_;
	
	if ($url) {
		$self->{_URL} = $url;
	}
	else {
		return $self->{_URL};
	}
}

sub date(;$) {
	my ($self, $date) = @_;
	
	if ($date) {
		$self->{_DATE} = $date;
	}
	else {
		return $self->{_DATE};
	}
}

sub type(;$) {
	my ($self, $type) = @_;
	
	if ($type) {
		$self->{_TYPE} = $type;
	}
	else {
		return $self->{_TYPE};
	}
}

sub __Tidy($) {
	my ($input) = @_;
	
	return HTML::Strip->new()->parse(decode_entities($input));
}

1;